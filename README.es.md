# Asistente de IA de SUP Dropshipping (Agent Skills + MCP)

[English](./README.md) · [简体中文](./README.zh-CN.md) · [日本語](./README.ja.md) · [Español](./README.es.md) · [Français](./README.fr.md) · [Deutsch](./README.de.md) · [Português](./README.pt-BR.md)

Pregunta a tu herramienta de IA, en lenguaje natural, por tu cuenta de SUP Dropshipping: pedidos, costes, números de seguimiento, productos vinculados, inventario privado, historial del monedero, facturas y solicitudes de sourcing. **Solo lectura**: no puede pagar, cancelar ni modificar nada.

## Dos formas de usarlo

| | Skills (este repositorio) | Servidor MCP |
| --- | --- | --- |
| Instalación | Ejecutar el instalador una vez en cada ordenador | Añadir una URL en tu herramienta de IA |
| Inicio de sesión | Aprobación en el navegador | Aprobación en el navegador |
| Funciona en | Herramientas locales como Claude Code, Codex, Cursor | Cualquier herramienta con MCP remoto, incluidas las apps de Claude y ChatGPT |

Ambas leen los mismos datos y puedes usarlas a la vez. Nunca tendrás que copiar una clave ni escribir tu contraseña en la herramienta de IA.

## Opción 1: instalar las skills

**macOS / Linux:**

```sh
curl -fsSL https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.sh | sh
```

**Windows PowerShell:**

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; & ([scriptblock]::Create((Invoke-RestMethod 'https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.ps1')))"
```

El instalador detecta las herramientas de IA de tu ordenador e instala las skills en cada una, sin tocar tus otras skills. No necesitas `git` ni `npm`. Después, **reinicia tu herramienta de IA**.

### Conectar tu cuenta (una vez por ordenador)

Pide a tu herramienta de IA:

```text
Conéctate a mi cuenta de SUP Dropshipping.
```

1. Se abre en el navegador una página de supdropshipping.com (si no se abre, la herramienta de IA te muestra el enlace).
2. Inicia sesión con tu cuenta habitual de SUP Dropshipping si te lo pide.
3. Comprueba que el código de 8 caracteres de la página coincide con el de la herramienta de IA y haz clic en **Allow**.

La conexión se guarda en este ordenador y se reutiliza. Cada cuenta tiene una sola conexión de skills: si conectas un segundo ordenador, el primero se desconecta; vuelve a conectar en el que estés usando.

## Opción 2: conectar el servidor MCP

URL del servidor:

```
https://www.supdropshipping.com/mcp
```

La primera vez que tu herramienta se conecte, abrirá una página de SUP Dropshipping en el navegador: inicia sesión, comprueba el nombre de la app y haz clic en **Allow**. Cada herramienta y cada ordenador tienen su propia conexión.

- **Claude (web, escritorio y móvil):** en la configuración de conectores, añade un conector personalizado con el nombre `SUP Dropshipping` y la URL anterior. Deja vacíos el Client ID y el Secret, conecta y aprueba.
- **Claude Code:** ejecuta `claude mcp add --transport http sup-dropshipping https://www.supdropshipping.com/mcp` y luego, en Claude Code, `/mcp` → `sup-dropshipping` → **Authenticate**.
- **Codex CLI:** `codex mcp add sup-dropshipping --url https://www.supdropshipping.com/mcp` y después `codex mcp login sup-dropshipping`.
- **Cursor, VS Code, Gemini CLI, ChatGPT y otras:** consulta [MCP_GUIDE.md](./MCP_GUIDE.md) o [www.supdropshipping.com/ai/mcp](https://www.supdropshipping.com/ai/mcp).

## Qué puedes preguntar

```text
Muéstrame el resumen de mi cuenta de SUP: saldo, crédito disponible y cuántos pedidos hay en cada estado.
```

```text
Lista mis pedidos pendientes de pago con el número de pedido de la tienda, el país del comprador y el coste total.
```

```text
¿En qué estado está el pedido #1001 de mi tienda y cuál es su número de seguimiento?
```

```text
¿Cuánto le he pagado a SUP este mes? Muestra los reembolsos por separado.
```

```text
¿Qué artículos de mi inventario privado tienen menos de 20 unidades?
```

```text
¿Qué solicitudes de sourcing siguen pendientes y qué ha respondido SUP a las demás?
```

Si preguntas en español, la IA responde en español. Los importes están en USD y las horas en UTC+8.

## Seguridad

- **Solo lectura:** no puede pagar, cancelar, editar ni hacer pedidos. Hazlo en el sitio web de SUP Dropshipping.
- **Tú lo apruebas:** solo se conecta después de que inicies sesión en supdropshipping.com y hagas clic en Allow. La herramienta de IA nunca ve tu contraseña.
- **Solo tus datos:** cada conexión solo puede leer la cuenta que la aprobó.
- Política de privacidad: [www.supdropshipping.com/privacy-policy](https://www.supdropshipping.com/privacy-policy/)

## Solución de problemas

| Qué ves | Qué hacer |
| --- | --- |
| 401 Unauthorized | La conexión se sustituyó o dejó de ser válida. Pide a la herramienta de IA que vuelva a conectarse. |
| La página dice que el código no existe o ha caducado | Los códigos valen 10 minutos y un solo uso. Vuelve a iniciar la conexión. |
| 429 / Rate limit | Demasiadas solicitudes en un minuto (máximo 60). Espera un minuto y vuelve a intentarlo. |
| El instalador no encuentra herramientas | Instala la herramienta de IA, ábrela una vez y vuelve a ejecutar el instalador. |
| MCP pide iniciar sesión una y otra vez | Comprueba que la herramienta puede abrir el navegador y que la hora del ordenador es correcta. |

## Más documentación (en inglés)

- [QUICK_START.md](./QUICK_START.md): inicio rápido
- [USER_GUIDE.md](./USER_GUIDE.md): guía completa con ejemplos
- [MCP_GUIDE.md](./MCP_GUIDE.md): conexión del servidor MCP
- Ayuda: [contactar con SUP Dropshipping](https://www.supdropshipping.com/contact/)
