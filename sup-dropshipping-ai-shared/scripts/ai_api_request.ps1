# SUP Dropshipping read-only AI API helper (Windows PowerShell 5.1+ / PowerShell 7).
#
#   ai_api_request.ps1 status
#   ai_api_request.ps1 login [--wait] [--no-browser] [--scope user|repo]
#   ai_api_request.ps1 set-from-env [--scope user|repo]
#   ai_api_request.ps1 request /api/ai/v1/orders [--param key=value ...]
#
# Credentials are resolved from environment variables, then config files.
# The secret is never printed.

$ErrorActionPreference = 'Stop'

$DefaultBaseUrl = 'https://www.supdropshipping.com'
$HomeDir = if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }
$UserConfig = Join-Path $HomeDir '.sup-dropshipping\ai-api.json'
$LoginPending = Join-Path $HomeDir '.sup-dropshipping\login-pending.json'
$LoginWaitSeconds = if ($env:SUP_AI_LOGIN_WAIT) { [int]$env:SUP_AI_LOGIN_WAIT } else { 100 }
$RepoConfigName = '.sup-dropshipping-ai.local.json'

function Fail([string]$Message) {
    [Console]::Error.WriteLine("ERROR: $Message")
    exit 1
}

function Read-ConfigFile([string]$Path) {
    if (-not $Path -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    try {
        return Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json
    } catch {
        Fail "config file is not valid JSON: $Path"
    }
}

function Find-RepoConfig {
    $dir = (Get-Location).ProviderPath
    while ($dir) {
        $candidate = Join-Path $dir $RepoConfigName
        if (Test-Path -LiteralPath $candidate -PathType Leaf) { return $candidate }
        $parent = Split-Path -Parent $dir
        if (-not $parent -or $parent -eq $dir) { break }
        $dir = $parent
    }
    return $null
}

function Get-ConfigValue($Config, [string]$Lower, [string]$Upper) {
    if ($null -eq $Config) { return $null }
    foreach ($name in @($Lower, $Upper)) {
        $prop = $Config.PSObject.Properties[$name]
        if ($prop -and $prop.Value) { return [string]$prop.Value }
    }
    return $null
}

function Resolve-Credentials {
    $state = @{
        BaseUrl = $null; AccessKeyId = $null; Secret = $null
        BaseUrlSource = 'default'; AccessKeyIdSource = 'missing'; SecretSource = 'missing'
    }
    if ($env:SUP_AI_BASE_URL) { $state.BaseUrl = $env:SUP_AI_BASE_URL; $state.BaseUrlSource = 'env' }
    if ($env:SUP_AI_ACCESS_KEY_ID) { $state.AccessKeyId = $env:SUP_AI_ACCESS_KEY_ID; $state.AccessKeyIdSource = 'env' }
    if ($env:SUP_AI_SECRET) { $state.Secret = $env:SUP_AI_SECRET; $state.SecretSource = 'env' }

    $files = @()
    if ($env:SUP_AI_CONFIG) { $files += $env:SUP_AI_CONFIG }
    $repo = Find-RepoConfig
    if ($repo) { $files += $repo }
    $files += $UserConfig

    foreach ($file in $files) {
        $config = Read-ConfigFile $file
        if ($null -eq $config) { continue }
        if (-not $state.BaseUrl) {
            $value = Get-ConfigValue $config 'base_url' 'SUP_AI_BASE_URL'
            if ($value) { $state.BaseUrl = $value; $state.BaseUrlSource = "config:$file" }
        }
        if (-not $state.AccessKeyId) {
            $value = Get-ConfigValue $config 'access_key_id' 'SUP_AI_ACCESS_KEY_ID'
            if ($value) { $state.AccessKeyId = $value; $state.AccessKeyIdSource = "config:$file" }
        }
        if (-not $state.Secret) {
            $value = Get-ConfigValue $config 'secret' 'SUP_AI_SECRET'
            if ($value) { $state.Secret = $value; $state.SecretSource = "config:$file" }
        }
    }

    if (-not $state.BaseUrl) { $state.BaseUrl = $DefaultBaseUrl }
    $state.BaseUrl = $state.BaseUrl.TrimEnd('/')
    return $state
}

# Credentials issued by SUP only contain letters, digits, "_" and "-".
function Assert-TokenChars([string]$Name, [string]$Value) {
    if ($Value -notmatch '^[A-Za-z0-9_-]+$') {
        Fail "$Name contains unexpected characters; copy it again from the SUP account page"
    }
}

function Invoke-Status {
    $c = Resolve-Credentials
    Write-Output "base_url: $($c.BaseUrl) ($($c.BaseUrlSource))"
    if ($c.AccessKeyId) { Write-Output "access_key_id: set ($($c.AccessKeyIdSource))" } else { Write-Output 'access_key_id: missing' }
    if ($c.Secret) { Write-Output "secret: set ($($c.SecretSource))" } else { Write-Output 'secret: missing' }
    if ($c.AccessKeyId -and $c.Secret) {
        Write-Output 'ready: yes'
    } else {
        Write-Output 'ready: no'
        Write-Output 'To connect, run: ai_api_request.ps1 login'
        exit 2
    }
}

function Write-Config([string]$Scope, [string]$BaseUrl, [string]$AccessKeyId, [string]$Secret) {
    switch ($Scope) {
        'user' { $target = $UserConfig }
        'repo' { $target = Join-Path (Get-Location).ProviderPath $RepoConfigName }
        default { Fail '--scope must be user or repo' }
    }
    $dir = Split-Path -Parent $target
    if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $json = [ordered]@{
        base_url      = $BaseUrl.TrimEnd('/')
        access_key_id = $AccessKeyId
        secret        = $Secret
    } | ConvertTo-Json
    [System.IO.File]::WriteAllText($target, $json + "`n", (New-Object System.Text.UTF8Encoding($false)))
    return $target
}

function Invoke-SetFromEnv([string[]]$Rest) {
    $scope = 'user'
    for ($i = 0; $i -lt $Rest.Count; $i++) {
        if ($Rest[$i] -eq '--scope' -and ($i + 1) -lt $Rest.Count) { $scope = $Rest[$i + 1]; $i++ }
        else { Fail "unknown argument: $($Rest[$i])" }
    }
    if (-not $env:SUP_AI_ACCESS_KEY_ID) { Fail 'SUP_AI_ACCESS_KEY_ID is not set in the environment' }
    if (-not $env:SUP_AI_SECRET) { Fail 'SUP_AI_SECRET is not set in the environment' }
    Assert-TokenChars 'SUP_AI_ACCESS_KEY_ID' $env:SUP_AI_ACCESS_KEY_ID
    Assert-TokenChars 'SUP_AI_SECRET' $env:SUP_AI_SECRET
    $baseUrl = if ($env:SUP_AI_BASE_URL) { $env:SUP_AI_BASE_URL } else { $DefaultBaseUrl }
    $target = Write-Config $scope $baseUrl $env:SUP_AI_ACCESS_KEY_ID $env:SUP_AI_SECRET
    Write-Output "Saved credentials to $target"
    if ($scope -eq 'repo') { Write-Output "Make sure $RepoConfigName is listed in .gitignore." }
}

# POST a form without credentials. Returns @{ Status = <int>; Body = <object or $null>; Raw = <string> }
function Invoke-PostForm([string]$BaseUrl, [string]$Path, [hashtable]$Fields) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    $pairs = @()
    foreach ($k in $Fields.Keys) { $pairs += ([uri]::EscapeDataString($k) + '=' + [uri]::EscapeDataString([string]$Fields[$k])) }
    $bytes = [System.Text.Encoding]::UTF8.GetBytes(($pairs -join '&'))
    $request = [System.Net.HttpWebRequest]::Create($BaseUrl + $Path)
    $request.Method = 'POST'
    $request.Accept = 'application/json'
    $request.ContentType = 'application/x-www-form-urlencoded'
    $request.Timeout = 30000
    $request.ContentLength = $bytes.Length
    try {
        $stream = $request.GetRequestStream(); $stream.Write($bytes, 0, $bytes.Length); $stream.Close()
        $response = $request.GetResponse()
    } catch [System.Net.WebException] {
        $response = $_.Exception.Response
        if ($null -eq $response) { Fail "could not reach $BaseUrl (network error): $($_.Exception.Message)" }
    }
    $reader = New-Object System.IO.StreamReader($response.GetResponseStream(), [System.Text.Encoding]::UTF8)
    $raw = $reader.ReadToEnd(); $reader.Close()
    $status = [int]$response.StatusCode
    $response.Close()
    $body = $null
    try { $body = $raw | ConvertFrom-Json } catch { }
    return @{ Status = $status; Body = $body; Raw = $raw }
}

# Browser sign-in: the user approves in their SUP Dropshipping account and the
# credential is saved locally. It never passes through the chat.
function Invoke-Login([string[]]$Rest) {
    $scope = 'user'; $waitOnly = $false; $noBrowser = $false
    for ($i = 0; $i -lt $Rest.Count; $i++) {
        switch ($Rest[$i]) {
            '--scope' { if (($i + 1) -ge $Rest.Count) { Fail '--scope needs a value' }; $scope = $Rest[$i + 1]; $i++ }
            '--wait' { $waitOnly = $true }
            '--no-browser' { $noBrowser = $true }
            default { Fail "unknown argument: $($Rest[$i])" }
        }
    }
    if ($scope -ne 'user' -and $scope -ne 'repo') { Fail '--scope must be user or repo' }
    $c = Resolve-Credentials
    $baseUrl = $c.BaseUrl

    if ($waitOnly) {
        if (-not (Test-Path -LiteralPath $LoginPending)) { Fail 'no sign-in is in progress; run: ai_api_request.ps1 login' }
        $pending = Get-Content -LiteralPath $LoginPending -Raw -Encoding UTF8 | ConvertFrom-Json
        $baseUrl = $pending.base_url; $scope = $pending.scope
        Write-Output "Still waiting for approval of code $($pending.user_code) at:"
        Write-Output "  $($pending.url)"
    } else {
        $clientName = "$([System.Net.Dns]::GetHostName()) (Windows)"
        $r = Invoke-PostForm $baseUrl '/api/ai/device/code' @{ client_name = $clientName }
        if ($r.Status -ne 200 -or $null -eq $r.Body -or -not $r.Body.device_code) { Fail "could not start sign-in (HTTP $($r.Status)): $($r.Raw)" }
        $pending = [ordered]@{
            device_code = $r.Body.device_code
            user_code   = $r.Body.user_code
            url         = $r.Body.verification_uri_complete
            interval    = $r.Body.interval
            base_url    = $baseUrl
            scope       = $scope
        }
        $dir = Split-Path -Parent $LoginPending
        if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        [System.IO.File]::WriteAllText($LoginPending, ($pending | ConvertTo-Json), (New-Object System.Text.UTF8Encoding($false)))
        $pending = [pscustomobject]$pending

        Write-Output 'To connect this computer to your SUP Dropshipping account:'
        Write-Output '  1. Open this link (sign in to SUP Dropshipping if asked):'
        Write-Output "     $($pending.url)"
        Write-Output "  2. Check that the page shows the code: $($pending.user_code)"
        Write-Output '  3. Click "Allow".'
        if (-not $noBrowser) {
            try { Start-Process $pending.url | Out-Null; Write-Output 'The link was opened in your browser.' } catch { }
        }
        Write-Output 'Waiting for approval...'
    }

    $interval = [int]$pending.interval
    if ($interval -lt 1) { $interval = 5 }
    $waited = 0
    while ($waited -lt $LoginWaitSeconds) {
        Start-Sleep -Seconds $interval
        $waited += $interval
        $r = Invoke-PostForm $baseUrl '/api/ai/device/token' @{ device_code = $pending.device_code }
        if ($r.Status -eq 200 -and $r.Body -and $r.Body.access_key_id) {
            Assert-TokenChars 'access_key_id' $r.Body.access_key_id
            Assert-TokenChars 'secret' $r.Body.secret
            $savedBase = if ($r.Body.base_url) { $r.Body.base_url } else { $baseUrl }
            $target = Write-Config $scope $savedBase $r.Body.access_key_id $r.Body.secret
            Remove-Item -LiteralPath $LoginPending -Force -ErrorAction SilentlyContinue
            $as = if ($r.Body.account) { " as $($r.Body.account)" } else { '' }
            Write-Output "Connected$as. Credentials saved to $target"
            exit 0
        }
        $code = if ($r.Body) { [string]$r.Body.code } else { '' }
        switch ($code) {
            'authorization_pending' { }
            'slow_down' { $interval += 5 }
            'access_denied' { Remove-Item -LiteralPath $LoginPending -Force -ErrorAction SilentlyContinue; Fail 'the request was denied in the browser' }
            { $_ -eq 'expired_token' -or $_ -eq 'invalid_device_code' } { Remove-Item -LiteralPath $LoginPending -Force -ErrorAction SilentlyContinue; Fail 'the sign-in request expired or was already used; run: ai_api_request.ps1 login' }
            default { Fail "sign-in failed (HTTP $($r.Status)): $($r.Raw)" }
        }
    }
    Write-Output 'Not approved yet. After clicking "Allow" in the browser, run: ai_api_request.ps1 login --wait'
    exit 3
}

function Invoke-Request([string[]]$Rest) {
    if ($Rest.Count -lt 1) { Fail 'usage: ai_api_request.ps1 request /api/ai/v1/<resource> [--param key=value ...]' }
    $path = $Rest[0]
    if (-not $path.StartsWith('/api/ai/v1/')) { Fail "only /api/ai/v1/* paths are allowed (got: $path)" }
    if ($path -notmatch '^[A-Za-z0-9/_.-]+$') { Fail 'path contains unsupported characters; pass filters with --param key=value' }

    $pairs = @()
    for ($i = 1; $i -lt $Rest.Count; $i++) {
        if ($Rest[$i] -eq '--param' -and ($i + 1) -lt $Rest.Count) {
            $kv = $Rest[$i + 1]
            $eq = $kv.IndexOf('=')
            if ($eq -lt 1) { Fail "--param needs key=value (got: $kv)" }
            $pairs += ([uri]::EscapeDataString($kv.Substring(0, $eq)) + '=' + [uri]::EscapeDataString($kv.Substring($eq + 1)))
            $i++
        } else {
            Fail "unknown argument: $($Rest[$i])"
        }
    }

    $c = Resolve-Credentials
    if (-not ($c.AccessKeyId -and $c.Secret)) { Fail 'credentials are not configured; run: ai_api_request.ps1 status' }
    Assert-TokenChars 'access_key_id' $c.AccessKeyId
    Assert-TokenChars 'secret' $c.Secret

    $url = $c.BaseUrl + $path
    if ($pairs.Count -gt 0) { $url += '?' + ($pairs -join '&') }

    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    $request = [System.Net.HttpWebRequest]::Create($url)
    $request.Method = 'GET'
    $request.Accept = 'application/json'
    $request.Timeout = 60000
    $request.Headers.Add('Authorization', "Bearer $($c.AccessKeyId).$($c.Secret)")

    $response = $null
    try {
        $response = $request.GetResponse()
    } catch [System.Net.WebException] {
        $response = $_.Exception.Response
        if ($null -eq $response) { Fail "request failed (network error): $($_.Exception.Message)" }
    }

    $status = [int]$response.StatusCode
    $reader = New-Object System.IO.StreamReader($response.GetResponseStream(), [System.Text.Encoding]::UTF8)
    $body = $reader.ReadToEnd()
    $reader.Close()

    Write-Output $body
    [Console]::Error.WriteLine("HTTP $status")
    foreach ($name in @('X-RateLimit-Limit', 'X-RateLimit-Remaining', 'X-RateLimit-Reset', 'Retry-After')) {
        $value = $response.Headers[$name]
        if ($value) { [Console]::Error.WriteLine("${name}: $value") }
    }
    $response.Close()

    if ($status -ge 200 -and $status -lt 300) { exit 0 } else { exit 1 }
}

if ($args.Count -lt 1) {
    Fail 'usage: ai_api_request.ps1 status | login [--wait] | set-from-env [--scope user|repo] | request <path> [--param key=value ...]'
}
$command = [string]$args[0]
$rest = @()
if ($args.Count -gt 1) { $rest = @($args[1..($args.Count - 1)] | ForEach-Object { [string]$_ }) }

switch ($command) {
    'status' { Invoke-Status }
    'login' { Invoke-Login $rest }
    'set-from-env' { Invoke-SetFromEnv $rest }
    'request' { Invoke-Request $rest }
    default { Fail "unknown command: $command" }
}
