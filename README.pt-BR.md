# Assistente de IA da SUP Dropshipping (Agent Skills + MCP)

[English](./README.md) · [简体中文](./README.zh-CN.md) · [日本語](./README.ja.md) · [Español](./README.es.md) · [Français](./README.fr.md) · [Deutsch](./README.de.md) · [Português](./README.pt-BR.md)

Pergunte à sua ferramenta de IA, em linguagem natural, sobre sua conta SUP Dropshipping: pedidos, custos, códigos de rastreio, produtos conectados, estoque privado, histórico da carteira, faturas e solicitações de sourcing. **Somente leitura**: não é possível pagar, cancelar ou alterar nada.

## Duas formas de usar

| | Skills (este repositório) | Servidor MCP |
| --- | --- | --- |
| Instalação | Executar o instalador uma vez em cada computador | Adicionar uma URL na sua ferramenta de IA |
| Login | Aprovação no navegador | Aprovação no navegador |
| Funciona em | Ferramentas locais como Claude Code, Codex, Cursor | Qualquer ferramenta com MCP remoto, incluindo os apps do Claude e do ChatGPT |

As duas leem os mesmos dados e podem ser usadas juntas. Você nunca precisa copiar uma chave nem digitar sua senha na ferramenta de IA.

## Opção 1: instalar as skills

**macOS / Linux:**

```sh
curl -fsSL https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.sh | sh
```

**Windows PowerShell:**

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; & ([scriptblock]::Create((Invoke-RestMethod 'https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.ps1')))"
```

O instalador encontra as ferramentas de IA do seu computador e instala as skills em cada uma, sem mexer nas suas outras skills. Não é preciso `git` nem `npm`. Depois, **reinicie sua ferramenta de IA**.

### Conectar sua conta (uma vez por computador)

Peça à sua ferramenta de IA:

```text
Conecte-se à minha conta SUP Dropshipping.
```

1. Uma página de supdropshipping.com abre no navegador (se não abrir, a ferramenta de IA mostra o link).
2. Faça login com sua conta SUP Dropshipping de sempre, se for pedido.
3. Confira se o código de 8 caracteres da página é igual ao da ferramenta de IA e clique em **Allow**.

A conexão fica salva neste computador e é reutilizada. Cada conta tem uma única conexão de skills: conectar um segundo computador desconecta o primeiro; basta conectar de novo no computador que você estiver usando.

## Opção 2: conectar o servidor MCP

URL do servidor:

```
https://www.supdropshipping.com/mcp
```

Na primeira conexão, sua ferramenta abre uma página da SUP Dropshipping no navegador: faça login, confira o nome do app e clique em **Allow**. Cada ferramenta e cada computador têm sua própria conexão.

- **Claude (web, desktop e celular):** nas configurações de conectores, adicione um conector personalizado chamado `SUP Dropshipping` com a URL acima. Deixe o Client ID e o Secret em branco, conecte e aprove.
- **Claude Code:** execute `claude mcp add --transport http sup-dropshipping https://www.supdropshipping.com/mcp` e, no Claude Code, `/mcp` → `sup-dropshipping` → **Authenticate**.
- **Codex CLI:** `codex mcp add sup-dropshipping --url https://www.supdropshipping.com/mcp` e depois `codex mcp login sup-dropshipping`.
- **Cursor, VS Code, Gemini CLI, ChatGPT e outros:** veja [MCP_GUIDE.md](./MCP_GUIDE.md) ou [www.supdropshipping.com/ai/mcp](https://www.supdropshipping.com/ai/mcp).

## O que você pode perguntar

```text
Mostre o resumo da minha conta SUP: saldo, crédito disponível e quantos pedidos há em cada status.
```

```text
Liste meus pedidos aguardando pagamento, com o número do pedido na loja, o país do comprador e o custo total.
```

```text
Qual é o status do pedido #1001 da minha loja e qual é o código de rastreio?
```

```text
Quanto paguei à SUP este mês? Mostre os reembolsos separadamente.
```

```text
Quais itens do meu estoque privado têm menos de 20 unidades?
```

```text
Quais solicitações de sourcing ainda estão pendentes e o que a SUP respondeu nas outras?
```

Se você perguntar em português, a IA responde em português. Os valores estão em USD e os horários em UTC+8.

## Segurança

- **Somente leitura:** não é possível pagar, cancelar, editar nem fazer pedidos. Faça isso no site da SUP Dropshipping.
- **Você aprova:** a conexão só acontece depois que você faz login em supdropshipping.com e clica em Allow. A ferramenta de IA nunca vê sua senha.
- **Só os seus dados:** cada conexão só pode ler a conta que a aprovou.
- Política de privacidade: [www.supdropshipping.com/privacy-policy](https://www.supdropshipping.com/privacy-policy/)

## Solução de problemas

| O que aparece | O que fazer |
| --- | --- |
| 401 Unauthorized | A conexão foi substituída ou não é mais válida. Peça à ferramenta de IA para conectar de novo. |
| A página diz que o código não existe ou expirou | Os códigos valem 10 minutos e só podem ser usados uma vez. Inicie a conexão novamente. |
| 429 / Rate limit | Muitas solicitações em um minuto (máximo de 60). Espere um minuto e tente de novo. |
| O instalador não encontra ferramentas | Instale a ferramenta de IA, abra-a uma vez e execute o instalador de novo. |
| O MCP pede login várias vezes | Verifique se a ferramenta consegue abrir o navegador e se o relógio do computador está certo. |

## Mais documentação (em inglês)

- [QUICK_START.md](./QUICK_START.md): início rápido
- [USER_GUIDE.md](./USER_GUIDE.md): guia completo com exemplos
- [MCP_GUIDE.md](./MCP_GUIDE.md): conexão do servidor MCP
- Ajuda: [fale com a SUP Dropshipping](https://www.supdropshipping.com/contact/)
