# SUP Dropshipping AI アシスタント（Agent Skills + MCP）

[English](./README.md) · [简体中文](./README.zh-CN.md) · [日本語](./README.ja.md) · [Español](./README.es.md) · [Français](./README.fr.md) · [Deutsch](./README.de.md) · [Português](./README.pt-BR.md)

AI ツールに自然な言葉で質問して、SUP Dropshipping アカウントの注文、コスト、追跡番号、連携商品、プライベート在庫、ウォレット履歴、請求書、仕入れ依頼を確認できます。**読み取り専用**です。支払い、キャンセル、変更は一切できません。

## 2 つの使い方

| | Skills（このリポジトリ） | MCP サーバー |
| --- | --- | --- |
| インストール | パソコンごとにインストールコマンドを 1 回実行 | AI ツールに URL を 1 つ追加 |
| サインイン | ブラウザで承認 | ブラウザで承認 |
| 対応ツール | Claude Code、Codex、Cursor などのローカル AI ツール | リモート MCP に対応したすべてのツール（Claude、ChatGPT のアプリを含む） |

どちらも同じデータを読み取るので、併用できます。キーをコピーしたり、AI ツールにパスワードを入力したりする必要はありません。

## 方法 1：Skills をインストール

**macOS / Linux：**

```sh
curl -fsSL https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.sh | sh
```

**Windows PowerShell：**

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; & ([scriptblock]::Create((Invoke-RestMethod 'https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.ps1')))"
```

インストーラーはパソコン上の AI ツールを自動で見つけてスキルを追加します。ほかのスキルには影響しません。`git` や `npm` は不要です。インストール後、**AI ツールを再起動**してください。

### アカウントを接続（パソコンごとに 1 回）

AI ツールに次のように伝えます：

```text
SUP Dropshipping のアカウントに接続して
```

1. ブラウザで supdropshipping.com の承認ページが開きます（開かない場合は AI ツールがリンクを表示します）。
2. 必要に応じて、いつもの SUP Dropshipping アカウントでログインします。
3. ページに表示された 8 文字のコードが AI ツールのコードと一致することを確認し、**Allow** をクリックします。

接続はこのパソコンに保存され、次回から自動で使われます。Skills の接続は 1 アカウントにつき 1 つです。別のパソコンで接続すると前の接続は無効になるので、使うパソコンで接続し直してください。

## 方法 2：MCP サーバーに接続

サーバー URL：

```
https://www.supdropshipping.com/mcp
```

初回接続時に SUP Dropshipping の承認ページがブラウザで開きます。ログインしてアプリ名を確認し、**Allow** をクリックしてください。ツールやパソコンごとに個別の接続になります。

- **Claude（Web / デスクトップ / モバイル）**：コネクタ設定で「カスタムコネクタを追加」を選び、名前に `SUP Dropshipping`、URL に上記のアドレスを入力します。Client ID と Secret は空欄のまま接続し、承認します。
- **Claude Code**：`claude mcp add --transport http sup-dropshipping https://www.supdropshipping.com/mcp` を実行し、Claude Code で `/mcp` → `sup-dropshipping` → **Authenticate** を選びます。
- **Codex CLI**：`codex mcp add sup-dropshipping --url https://www.supdropshipping.com/mcp` の後に `codex mcp login sup-dropshipping` を実行します。
- **Cursor / VS Code / Gemini CLI / ChatGPT など**：[MCP_GUIDE.md](./MCP_GUIDE.md) または [www.supdropshipping.com/ai/mcp](https://www.supdropshipping.com/ai/mcp) を参照してください。

## 質問の例

```text
SUP アカウントの概要を見せて。残高、利用可能な与信、ステータスごとの注文数。
```

```text
支払い待ちの注文を、ストアの注文番号、購入者の国、合計コスト付きで一覧にして。
```

```text
ストア注文番号 #1001 のステータスと追跡番号を教えて。
```

```text
今月 SUP にいくら支払った？返金は別に表示して。
```

```text
プライベート在庫で残り 20 個未満の商品は？
```

```text
回答待ちの仕入れ依頼はどれ？回答済みのものは SUP の見積もりを教えて。
```

日本語で質問すれば日本語で回答します。金額は米ドル、時刻は UTC+8 です。

## セキュリティ

- **読み取り専用**：支払い、キャンセル、編集、発注はできません。これらは SUP Dropshipping の Web サイトで行ってください。
- **承認はあなた自身**：Web サイトでログインして Allow をクリックした場合にのみ接続されます。AI ツールがパスワードを見ることはありません。
- **自分のデータのみ**：各接続は承認したアカウントのデータだけを読み取れます。
- プライバシーポリシー：[www.supdropshipping.com/privacy-policy](https://www.supdropshipping.com/privacy-policy/)

## トラブルシューティング

| 症状 | 対処 |
| --- | --- |
| 401 Unauthorized | 接続が置き換えられたか無効になっています。AI ツールにもう一度接続するよう頼んでください。 |
| 承認ページでコードが見つからない / 期限切れ | コードの有効期限は 10 分で、1 回だけ使えます。もう一度接続を始めてください。 |
| 429 / Rate limit | 1 分間のリクエストが多すぎます（上限 60 回）。1 分待ってから再試行してください。 |
| インストール時にツールが見つからない | 先に AI ツールをインストールして一度起動し、インストーラーを再実行してください。 |
| MCP で何度もサインインを求められる | ツールがこのパソコンでブラウザを開けること、パソコンの時刻が正しいことを確認してください。 |

## 詳しいドキュメント（英語）

- [QUICK_START.md](./QUICK_START.md)：クイックスタート
- [USER_GUIDE.md](./USER_GUIDE.md)：詳しい使い方と活用例
- [MCP_GUIDE.md](./MCP_GUIDE.md)：MCP サーバーの接続方法
- サポート：[SUP Dropshipping に問い合わせる](https://www.supdropshipping.com/contact/)
