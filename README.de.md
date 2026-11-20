# SUP Dropshipping KI-Assistent (Agent Skills + MCP)

[English](./README.md) · [简体中文](./README.zh-CN.md) · [日本語](./README.ja.md) · [Español](./README.es.md) · [Français](./README.fr.md) · [Deutsch](./README.de.md) · [Português](./README.pt-BR.md)

Frag dein KI-Tool in natürlicher Sprache nach deinem SUP-Dropshipping-Konto: Bestellungen, Kosten, Sendungsnummern, verknüpfte Produkte, privater Lagerbestand, Wallet-Verlauf, Rechnungen und Sourcing-Anfragen. **Nur Lesezugriff**: Es kann nichts bezahlt, storniert oder geändert werden.

## Zwei Möglichkeiten

| | Skills (dieses Repository) | MCP-Server |
| --- | --- | --- |
| Installation | Installer einmal pro Computer ausführen | Eine URL im KI-Tool hinzufügen |
| Anmeldung | Freigabe im Browser | Freigabe im Browser |
| Funktioniert mit | Lokalen Tools wie Claude Code, Codex, Cursor | Allen Tools mit Remote-MCP, auch den Apps von Claude und ChatGPT |

Beide lesen dieselben Daten und lassen sich gleichzeitig nutzen. Du musst nie einen Schlüssel kopieren oder dein Passwort im KI-Tool eingeben.

## Option 1: Skills installieren

**macOS / Linux:**

```sh
curl -fsSL https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.sh | sh
```

**Windows PowerShell:**

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; & ([scriptblock]::Create((Invoke-RestMethod 'https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.ps1')))"
```

Der Installer findet die KI-Tools auf deinem Computer und installiert die Skills dort, ohne deine anderen Skills anzufassen. `git` oder `npm` werden nicht benötigt. Danach das **KI-Tool neu starten**.

### Konto verbinden (einmal pro Computer)

Sag deinem KI-Tool:

```text
Verbinde dich mit meinem SUP-Dropshipping-Konto.
```

1. Im Browser öffnet sich eine Seite von supdropshipping.com (falls nicht, zeigt das KI-Tool den Link an).
2. Melde dich bei Bedarf mit deinem üblichen SUP-Dropshipping-Konto an.
3. Prüfe, ob der 8-stellige Code auf der Seite mit dem Code im KI-Tool übereinstimmt, und klicke auf **Allow**.

Die Verbindung wird auf diesem Computer gespeichert und wiederverwendet. Jedes Konto hat genau eine Skills-Verbindung: Verbindest du einen zweiten Computer, wird der erste getrennt; verbinde dich einfach erneut auf dem Computer, den du gerade nutzt.

## Option 2: MCP-Server verbinden

Server-URL:

```
https://www.supdropshipping.com/mcp
```

Beim ersten Verbinden öffnet dein Tool eine SUP-Dropshipping-Seite im Browser: anmelden, App-Namen prüfen und auf **Allow** klicken. Jedes Tool und jeder Computer hat eine eigene Verbindung.

- **Claude (Web, Desktop, Mobil):** In den Connector-Einstellungen einen benutzerdefinierten Connector namens `SUP Dropshipping` mit der obigen URL hinzufügen. Client-ID und Secret leer lassen, verbinden und freigeben.
- **Claude Code:** `claude mcp add --transport http sup-dropshipping https://www.supdropshipping.com/mcp` ausführen, dann in Claude Code `/mcp` → `sup-dropshipping` → **Authenticate**.
- **Codex CLI:** `codex mcp add sup-dropshipping --url https://www.supdropshipping.com/mcp`, dann `codex mcp login sup-dropshipping`.
- **ChatGPT, Cursor, VS Code, Windsurf, Zed, Cline, Kiro, OpenCode, Gemini CLI und andere:** siehe [MCP_GUIDE.md](./MCP_GUIDE.md) oder [www.supdropshipping.com/ai/mcp](https://www.supdropshipping.com/ai/mcp).

## Beispielfragen

```text
Zeig mir die Übersicht meines SUP-Kontos: Guthaben, verfügbarer Kredit und Anzahl der Bestellungen pro Status.
```

```text
Liste meine Bestellungen auf, die auf Zahlung warten, mit Shop-Bestellnummer, Land des Käufers und Gesamtkosten.
```

```text
Wie ist der Status der Shop-Bestellung #1001 und wie lautet die Sendungsnummer?
```

```text
Wie viel habe ich diesen Monat an SUP bezahlt? Erstattungen bitte separat aufführen.
```

```text
Welche Artikel in meinem privaten Lager haben weniger als 20 Stück?
```

```text
Welche Sourcing-Anfragen sind noch offen, und was hat SUP auf die anderen geantwortet?
```

Fragst du auf Deutsch, antwortet die KI auf Deutsch. Beträge sind in USD, Zeiten in UTC+8.

## Sicherheit

- **Nur Lesezugriff:** Bezahlen, Stornieren, Bearbeiten oder Bestellen ist nicht möglich. Das erledigst du auf der SUP-Dropshipping-Website.
- **Du gibst frei:** Die Verbindung entsteht erst, wenn du dich auf supdropshipping.com anmeldest und auf Allow klickst. Das KI-Tool sieht dein Passwort nie.
- **Nur deine Daten:** Jede Verbindung kann nur das Konto lesen, das sie freigegeben hat.
- Datenschutzerklärung: [www.supdropshipping.com/privacy-policy](https://www.supdropshipping.com/privacy-policy/)

## Fehlerbehebung

| Was du siehst | Was zu tun ist |
| --- | --- |
| 401 Unauthorized | Die Verbindung wurde ersetzt oder ist ungültig. Bitte das KI-Tool, sich neu zu verbinden. |
| Die Seite meldet, der Code sei unbekannt oder abgelaufen | Codes gelten 10 Minuten und nur einmal. Starte die Verbindung neu. |
| 429 / Rate limit | Zu viele Anfragen in einer Minute (maximal 60). Eine Minute warten und erneut versuchen. |
| Der Installer findet keine Tools | Installiere das KI-Tool, starte es einmal und führe den Installer erneut aus. |
| MCP fragt immer wieder nach der Anmeldung | Prüfe, ob das Tool den Browser öffnen kann und ob die Uhrzeit des Computers stimmt. |

## Weitere Dokumentation (Englisch)

- [QUICK_START.md](./QUICK_START.md): Schnellstart
- [USER_GUIDE.md](./USER_GUIDE.md): ausführliche Anleitung mit Beispielen
- [MCP_GUIDE.md](./MCP_GUIDE.md): MCP-Server verbinden
- Hilfe: [SUP Dropshipping kontaktieren](https://www.supdropshipping.com/contact/)
