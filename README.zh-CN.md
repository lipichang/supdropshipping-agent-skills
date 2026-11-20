# SUP Dropshipping AI 助手（Agent Skills + MCP）

[English](./README.md) · [简体中文](./README.zh-CN.md) · [日本語](./README.ja.md) · [Español](./README.es.md) · [Français](./README.fr.md) · [Deutsch](./README.de.md) · [Português](./README.pt-BR.md)

用自然语言向 AI 工具查询你的 SUP Dropshipping 账户：订单、成本、物流单号、关联商品、私有库存、钱包流水、发票和采购询价。**只读**——不能付款、取消或修改任何东西。

## 两种使用方式

| | Skills（本仓库） | MCP 服务 |
| --- | --- | --- |
| 安装 | 每台电脑运行一次安装命令 | 在 AI 工具里填一个网址 |
| 登录 | 浏览器一键授权 | 浏览器一键授权 |
| 适用 | Claude Code、Codex、Cursor 等本地 AI 工具 | 支持远程 MCP 的所有工具，包括 Claude 和 ChatGPT 的网页版 / App |

两种方式读取的是同一份数据，可以同时使用。全程不需要复制密钥，也不会在 AI 工具里输入网站密码。

## 方式一：安装 Skills

**macOS / Linux：**

```sh
curl -fsSL https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.sh | sh
```

**Windows PowerShell：**

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; & ([scriptblock]::Create((Invoke-RestMethod 'https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.ps1')))"
```

安装程序会自动找到电脑上的 AI 工具并把技能装进去，不会影响你已有的其他技能。不需要 `git` 或 `npm`。装完后**重启 AI 工具**。

### 连接账号（每台电脑一次）

对 AI 工具说：

```text
连接我的 SUP Dropshipping 账号
```

1. 浏览器会打开 supdropshipping.com 的授权页（没打开的话，AI 工具会给出链接）。
2. 如需登录，用你平时的 SUP Dropshipping 账号登录。
3. 确认页面上的 8 位验证码和 AI 工具里显示的一致，点击 **Allow**。

连接保存在这台电脑上，以后自动使用。每个账号同一时间只有一个 Skills 连接，在第二台电脑上连接会让第一台失效，到正在用的电脑上重新连接即可。

## 方式二：连接 MCP 服务

服务地址：

```
https://www.supdropshipping.com/mcp
```

工具第一次连接时会在浏览器打开 SUP Dropshipping 授权页：登录、确认应用名称、点击 **Allow**。每个工具、每台电脑都是独立的连接，互不影响。

- **Claude（网页 / 桌面 / 手机）**：在连接器设置里选择"添加自定义连接器"，名称填 `SUP Dropshipping`，粘贴上面的地址，Client ID 和 Secret 留空，然后连接并授权。
- **Claude Code**：运行 `claude mcp add --transport http sup-dropshipping https://www.supdropshipping.com/mcp`，然后在 Claude Code 里输入 `/mcp`，选择 `sup-dropshipping` → **Authenticate**。
- **Codex CLI**：`codex mcp add sup-dropshipping --url https://www.supdropshipping.com/mcp`，再运行 `codex mcp login sup-dropshipping`。
- **Cursor / VS Code / Gemini CLI / ChatGPT 等**：配置方法见 [MCP_GUIDE.md](./MCP_GUIDE.md) 或 [www.supdropshipping.com/ai/mcp](https://www.supdropshipping.com/ai/mcp)。

## 可以问什么

```text
给我看一下 SUP 账户概况：余额、可用额度、各状态的订单数量。
```

```text
列出所有待付款的订单，包括店铺订单号、买家国家和总成本。
```

```text
店铺订单号 #1001 现在是什么状态？物流单号是多少？
```

```text
这个月我在 SUP 一共付了多少钱？退款单独列出来。
```

```text
我的私有库存里哪些商品少于 20 件？
```

```text
哪些采购询价还在等回复？已经回复的 SUP 报价是多少？
```

用中文提问，AI 就用中文回答。金额单位为美元，时间为 UTC+8。

## 安全说明

- **只读**：不能付款、取消、修改或下单，这些操作请在 SUP Dropshipping 网站上完成。
- **你来授权**：只有你在网站上登录并点击 Allow 后才能连接，AI 工具看不到你的密码。
- **只能看自己的数据**：每个连接只能读取授权它的那个账号。
- 隐私政策：[www.supdropshipping.com/privacy-policy](https://www.supdropshipping.com/privacy-policy/)

## 常见问题

| 现象 | 处理 |
| --- | --- |
| 401 Unauthorized | 连接被替换或已失效，让 AI 工具重新连接 SUP Dropshipping。 |
| 授权页提示验证码不存在或已过期 | 验证码 10 分钟内有效且只能用一次，让 AI 工具重新发起连接。 |
| 429 / Rate limit | 一分钟内请求太多（上限 60 次），等一分钟再试。 |
| 安装时提示没找到工具 | 先安装并启动一次 AI 工具，再重新运行安装命令。 |
| MCP 一直要求重新登录 | 确认工具能在这台电脑上打开浏览器，电脑时间正确。 |

## 更多文档（英文）

- [QUICK_START.md](./QUICK_START.md)：快速开始
- [USER_GUIDE.md](./USER_GUIDE.md)：完整操作说明和示例场景
- [MCP_GUIDE.md](./MCP_GUIDE.md)：MCP 服务连接说明
- 需要帮助：[联系 SUP Dropshipping](https://www.supdropshipping.com/contact/)
