# Installer for the SUP Dropshipping agent skills (Windows).
# Copies every sup-dropshipping-* skill folder into the skills directory of
# each AI tool detected under the current user's profile.
#
#   install.ps1 [-DryRun] [-Ref main] [-Tool claude_code,codex] [-SourceDir C:\path\to\repo]
#   install.cmd passes --dry-run / --ref / --tool / --source-dir through as well.

$ErrorActionPreference = 'Stop'

$RepoOwner = if ($env:SUP_AGENT_SKILLS_OWNER) { $env:SUP_AGENT_SKILLS_OWNER } else { 'YOUR_GITHUB_ORG' }
$RepoName = if ($env:SUP_AGENT_SKILLS_REPO) { $env:SUP_AGENT_SKILLS_REPO } else { 'supdropshipping-agent-skills' }
$SkillPrefix = 'sup-dropshipping-'
$BackupDirName = '.supdropshipping-agent-skills-backups'

$DryRun = $false
$Ref = 'main'
$SourceDir = ''
$SelectedTools = @()

function Fail([string]$Message) {
    [Console]::Error.WriteLine("ERROR: $Message")
    exit 1
}

for ($i = 0; $i -lt $args.Count; $i++) {
    $arg = [string]$args[$i]
    switch -Regex ($arg) {
        '^(--dry-run|-DryRun)$' { $DryRun = $true; break }
        '^(--ref|-Ref)$' { $i++; if ($i -ge $args.Count) { Fail "$arg needs a value" }; $Ref = [string]$args[$i]; break }
        '^(--tool|-Tool)$' { $i++; if ($i -ge $args.Count) { Fail "$arg needs a value" }; $SelectedTools += ([string]$args[$i]).Split(','); break }
        '^(--source-dir|-SourceDir)$' { $i++; if ($i -ge $args.Count) { Fail "$arg needs a value" }; $SourceDir = [string]$args[$i]; break }
        default { Fail "unknown argument: $arg" }
    }
}

$HomeDir = $env:USERPROFILE
$Tools = @(
    @{ Key = 'claude_code'; Name = 'Claude Code'; Detect = "$HomeDir\.claude"; Target = "$HomeDir\.claude\skills"; Level = 'verified' },
    @{ Key = 'codex'; Name = 'Codex'; Detect = "$HomeDir\.codex"; Target = "$HomeDir\.codex\skills"; Level = 'verified' },
    @{ Key = 'openclaw'; Name = 'OpenClaw'; Detect = "$HomeDir\.openclaw"; Target = "$HomeDir\.openclaw\skills"; Level = 'best-effort' },
    @{ Key = 'cursor'; Name = 'Cursor'; Detect = "$HomeDir\.cursor"; Target = "$HomeDir\.cursor\skills"; Level = 'best-effort' },
    @{ Key = 'antigravity'; Name = 'Antigravity'; Detect = "$HomeDir\.gemini\antigravity"; Target = "$HomeDir\.gemini\antigravity\skills"; Level = 'best-effort' },
    @{ Key = 'opencode'; Name = 'OpenCode'; Detect = "$HomeDir\.config\opencode"; Target = "$HomeDir\.config\opencode\skills"; Level = 'best-effort' },
    @{ Key = 'continue'; Name = 'Continue'; Detect = "$HomeDir\.continue"; Target = "$HomeDir\.continue\skills"; Level = 'best-effort' },
    @{ Key = 'gemini_cli'; Name = 'Gemini CLI'; Detect = "$HomeDir\.gemini"; Target = "$HomeDir\.gemini\skills"; Level = 'best-effort' },
    @{ Key = 'github_copilot'; Name = 'GitHub Copilot'; Detect = "$HomeDir\.copilot"; Target = "$HomeDir\.copilot\skills"; Level = 'best-effort' },
    @{ Key = 'qwen_code'; Name = 'Qwen Code'; Detect = "$HomeDir\.qwen"; Target = "$HomeDir\.qwen\skills"; Level = 'best-effort' },
    @{ Key = 'windsurf'; Name = 'Windsurf'; Detect = "$HomeDir\.codeium\windsurf"; Target = "$HomeDir\.codeium\windsurf\skills"; Level = 'best-effort' }
)

$knownKeys = $Tools | ForEach-Object { $_.Key }
foreach ($selected in $SelectedTools) {
    if ($knownKeys -notcontains $selected) { Fail "unknown tool key: $selected" }
}

$TempDir = $null
$SourceRoot = $null
$ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { $null }

try {
    if ($SourceDir) {
        if (-not (Test-Path -LiteralPath $SourceDir -PathType Container)) { Fail "source directory not found: $SourceDir" }
        $SourceRoot = (Resolve-Path -LiteralPath $SourceDir).ProviderPath
    } elseif ($ScriptDir -and (Test-Path -LiteralPath (Join-Path $ScriptDir "${SkillPrefix}ai-shared\SKILL.md"))) {
        $SourceRoot = $ScriptDir
    } else {
        if ($RepoOwner -eq 'YOUR_GITHUB_ORG') { Fail 'the GitHub owner is not configured; set SUP_AGENT_SKILLS_OWNER or use -SourceDir' }
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
        $TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ('sup-agent-skills-' + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
        $archive = Join-Path $TempDir 'source.zip'
        Write-Output "Downloading $RepoOwner/$RepoName@$Ref ..."
        $downloaded = $false
        foreach ($kind in @('heads', 'tags')) {
            try {
                Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/$RepoOwner/$RepoName/archive/refs/$kind/$Ref.zip" -OutFile $archive
                $downloaded = $true
                break
            } catch { }
        }
        if (-not $downloaded) { Fail "could not download $RepoOwner/$RepoName at ref $Ref" }
        Expand-Archive -LiteralPath $archive -DestinationPath (Join-Path $TempDir 'src') -Force
        $shared = Get-ChildItem -LiteralPath (Join-Path $TempDir 'src') -Recurse -Directory -Filter "${SkillPrefix}ai-shared" | Select-Object -First 1
        if (-not $shared) { Fail "the downloaded archive does not contain ${SkillPrefix}ai-shared" }
        $SourceRoot = $shared.Parent.FullName
    }

    $Skills = @()
    foreach ($dir in (Get-ChildItem -LiteralPath $SourceRoot -Directory -Filter "$SkillPrefix*")) {
        $skillMd = Join-Path $dir.FullName 'SKILL.md'
        if (-not (Test-Path -LiteralPath $skillMd)) { continue }
        $nameLine = Get-Content -LiteralPath $skillMd -Encoding UTF8 | Where-Object { $_ -match '^name:\s*' } | Select-Object -First 1
        $declared = ($nameLine -replace '^name:\s*', '').Trim().Trim('"')
        if ($declared -ne $dir.Name) { Fail "skill folder $($dir.Name) does not match its frontmatter name ($declared)" }
        $Skills += $dir.Name
    }
    if ($Skills.Count -eq 0) { Fail "no $SkillPrefix* skills found in $SourceRoot" }

    $Timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $Installed = 0

    Write-Output "Source: $SourceRoot"
    Write-Output ("Skills: " + ($Skills -join ' '))
    Write-Output ''

    foreach ($tool in $Tools) {
        if ($SelectedTools.Count -gt 0 -and $SelectedTools -notcontains $tool.Key) { continue }
        if (-not (Test-Path -LiteralPath $tool.Detect -PathType Container)) { continue }
        $Installed++

        if ($DryRun) {
            Write-Output "DRY RUN  $($tool.Name) [$($tool.Level)] -> $($tool.Target)"
        } elseif (-not (Test-Path -LiteralPath $tool.Target)) {
            New-Item -ItemType Directory -Path $tool.Target -Force | Out-Null
        }

        foreach ($skill in $Skills) {
            $target = Join-Path $tool.Target $skill
            if (Test-Path -LiteralPath $target) {
                $backupRoot = Join-Path (Split-Path -Parent $tool.Target) "$BackupDirName\$($tool.Key)\$Timestamp"
                if ($DryRun) {
                    Write-Output "         backup $skill -> $backupRoot\$skill"
                } else {
                    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
                    Move-Item -LiteralPath $target -Destination (Join-Path $backupRoot $skill)
                }
            }
            if ($DryRun) {
                Write-Output "         copy   $skill"
            } else {
                Copy-Item -LiteralPath (Join-Path $SourceRoot $skill) -Destination $tool.Target -Recurse -Force
            }
        }

        if (-not $DryRun) { Write-Output "Installed into $($tool.Name) [$($tool.Level)]: $($tool.Target)" }
    }

    Write-Output ''
    if ($Installed -eq 0) {
        Fail 'no supported AI tool was detected. Install one first (for example Claude Code or Codex), or check the -Tool key.'
    }
    if ($DryRun) {
        Write-Output 'Dry run only. Nothing was changed.'
    } else {
        Write-Output 'Done. Restart your AI tool, then ask it to connect to your SUP Dropshipping account,'
        Write-Output 'and ask: "Show me my SUP Dropshipping account summary."'
    }
} finally {
    if ($TempDir -and (Test-Path -LiteralPath $TempDir)) { Remove-Item -LiteralPath $TempDir -Recurse -Force -ErrorAction SilentlyContinue }
}
