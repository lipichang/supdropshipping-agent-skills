# Assistant IA SUP Dropshipping (Agent Skills + MCP)

[English](./README.md) · [简体中文](./README.zh-CN.md) · [日本語](./README.ja.md) · [Español](./README.es.md) · [Français](./README.fr.md) · [Deutsch](./README.de.md) · [Português](./README.pt-BR.md)

Interrogez votre outil d'IA en langage naturel sur votre compte SUP Dropshipping : commandes, coûts, numéros de suivi, produits connectés, stock privé, historique du portefeuille, factures et demandes de sourcing. **Lecture seule** : rien ne peut être payé, annulé ou modifié.

## Deux façons de l'utiliser

| | Skills (ce dépôt) | Serveur MCP |
| --- | --- | --- |
| Installation | Lancer l'installateur une fois par ordinateur | Ajouter une URL dans votre outil d'IA |
| Connexion | Validation dans le navigateur | Validation dans le navigateur |
| Compatible avec | Outils locaux comme Claude Code, Codex, Cursor | Tout outil compatible MCP distant, y compris les apps Claude et ChatGPT |

Les deux lisent les mêmes données et peuvent être utilisés ensemble. Vous n'avez jamais à copier de clé ni à saisir votre mot de passe dans l'outil d'IA.

## Option 1 : installer les skills

**macOS / Linux :**

```sh
curl -fsSL https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.sh | sh
```

**Windows PowerShell :**

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; & ([scriptblock]::Create((Invoke-RestMethod 'https://raw.githubusercontent.com/lipichang/supdropshipping-agent-skills/main/install.ps1')))"
```

L'installateur détecte les outils d'IA de votre ordinateur et y installe les skills, sans toucher à vos autres skills. Ni `git` ni `npm` ne sont nécessaires. Ensuite, **redémarrez votre outil d'IA**.

### Connecter votre compte (une fois par ordinateur)

Demandez à votre outil d'IA :

```text
Connecte-toi à mon compte SUP Dropshipping.
```

1. Une page de supdropshipping.com s'ouvre dans le navigateur (sinon, l'outil d'IA affiche le lien).
2. Connectez-vous avec votre compte SUP Dropshipping habituel si nécessaire.
3. Vérifiez que le code de 8 caractères affiché sur la page correspond à celui de l'outil d'IA, puis cliquez sur **Allow**.

La connexion est enregistrée sur cet ordinateur et réutilisée. Chaque compte a une seule connexion skills : connecter un deuxième ordinateur déconnecte le premier ; reconnectez-vous simplement sur l'ordinateur que vous utilisez.

## Option 2 : connecter le serveur MCP

URL du serveur :

```
https://www.supdropshipping.com/mcp
```

À la première connexion, votre outil ouvre une page SUP Dropshipping dans le navigateur : connectez-vous, vérifiez le nom de l'application et cliquez sur **Allow**. Chaque outil et chaque ordinateur a sa propre connexion.

- **Claude (web, bureau et mobile) :** dans les paramètres des connecteurs, ajoutez un connecteur personnalisé nommé `SUP Dropshipping` avec l'URL ci-dessus. Laissez le Client ID et le Secret vides, connectez-vous et validez.
- **Claude Code :** exécutez `claude mcp add --transport http sup-dropshipping https://www.supdropshipping.com/mcp`, puis dans Claude Code `/mcp` → `sup-dropshipping` → **Authenticate**.
- **Codex CLI :** `codex mcp add sup-dropshipping --url https://www.supdropshipping.com/mcp`, puis `codex mcp login sup-dropshipping`.
- **ChatGPT, Cursor, VS Code, Windsurf, Zed, Cline, Kiro, OpenCode, Gemini CLI et autres :** voir [MCP_GUIDE.md](./MCP_GUIDE.md) ou [www.supdropshipping.com/ai/mcp](https://www.supdropshipping.com/ai/mcp).

## Exemples de questions

```text
Montre-moi le résumé de mon compte SUP : solde, crédit disponible et nombre de commandes par statut.
```

```text
Liste mes commandes en attente de paiement avec le numéro de commande de la boutique, le pays de l'acheteur et le coût total.
```

```text
Où en est la commande #1001 de ma boutique, et quel est son numéro de suivi ?
```

```text
Combien ai-je payé à SUP ce mois-ci ? Indique les remboursements à part.
```

```text
Quels articles de mon stock privé ont moins de 20 unités ?
```

```text
Quelles demandes de sourcing sont encore en attente, et qu'a répondu SUP aux autres ?
```

Posez vos questions en français, l'IA répond en français. Les montants sont en USD et les heures en UTC+8.

## Sécurité

- **Lecture seule :** impossible de payer, annuler, modifier ou passer commande. Faites-le sur le site SUP Dropshipping.
- **Vous validez :** la connexion n'est établie qu'après votre connexion sur supdropshipping.com et un clic sur Allow. L'outil d'IA ne voit jamais votre mot de passe.
- **Uniquement vos données :** chaque connexion ne peut lire que le compte qui l'a autorisée.
- Politique de confidentialité : [www.supdropshipping.com/privacy-policy](https://www.supdropshipping.com/privacy-policy/)

## Dépannage

| Ce que vous voyez | Que faire |
| --- | --- |
| 401 Unauthorized | La connexion a été remplacée ou n'est plus valide. Demandez à l'outil d'IA de se reconnecter. |
| La page indique que le code est introuvable ou expiré | Les codes sont valables 10 minutes et à usage unique. Relancez la connexion. |
| 429 / Rate limit | Trop de requêtes en une minute (60 maximum). Attendez une minute et réessayez. |
| L'installateur ne trouve aucun outil | Installez l'outil d'IA, lancez-le une fois, puis relancez l'installateur. |
| MCP redemande sans cesse la connexion | Vérifiez que l'outil peut ouvrir le navigateur et que l'horloge de l'ordinateur est à l'heure. |

## Documentation complète (en anglais)

- [QUICK_START.md](./QUICK_START.md) : démarrage rapide
- [USER_GUIDE.md](./USER_GUIDE.md) : guide complet avec exemples
- [MCP_GUIDE.md](./MCP_GUIDE.md) : connexion du serveur MCP
- Besoin d'aide : [contacter SUP Dropshipping](https://www.supdropshipping.com/contact/)
