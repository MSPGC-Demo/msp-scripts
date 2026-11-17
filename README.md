# msp-scripts

The running example from **Stop Emailing PowerShell Scripts: Source Control for MSP Teams** (MSPGeekcon 2027).

This repo follows one script, [`Get-DiskSpaceReport.ps1`](scripts/Get-DiskSpaceReport.ps1), through the workflow an MSP team can use for all of its scripts:

1. Work starts as an **issue**, the same way it would start as a ticket.
2. Changes happen on a **branch** and come back through a **pull request**.
3. **Checks** lint and test the script automatically before anyone can merge.
4. Pushing a version tag publishes a **release** your RMM can download.

## Get the latest scripts

Every release has the same download URLs, so an RMM job never needs updating:

```
https://github.com/MSPGC-Demo/msp-scripts/releases/latest/download/msp-scripts.zip
https://github.com/MSPGC-Demo/msp-scripts/releases/latest/download/msp-scripts.zip.sha256
```

See [GitHub Actions for scripts](docs/03-github-actions.md#downloading-a-release-from-your-rmm) for a download script that checks the checksum before extracting.

## What's in here

| Path | What it is |
| --- | --- |
| `scripts/` | The scripts that get released |
| `tests/` | [Pester](https://pester.dev) tests that run on every pull request |
| `.github/workflows/` | Two short workflows that call the org's [shared workflows](https://github.com/MSPGC-Demo/.github) |
| `PSScriptAnalyzerSettings.psd1` | Lint rules for this repo |
| `docs/` | Beginner guides (below) |

Issue forms, the pull request template, `CONTRIBUTING.md` and `SECURITY.md` don't live in this repo. They come from the org's [`.github`](https://github.com/MSPGC-Demo/.github) repo, so every repo in the org shares them.

## Guides

1. [Git basics](docs/01-git-basics.md)
2. [Issues, pull requests and Projects](docs/02-issues-prs-projects.md)
3. [GitHub Actions for scripts](docs/03-github-actions.md)
4. [Org-wide defaults with `.github`](docs/04-org-defaults.md)
5. [Cheat sheet](docs/cheatsheet.md)

## Run the checks locally

```powershell
Install-Module PSScriptAnalyzer, Pester -Scope CurrentUser
Invoke-ScriptAnalyzer -Path . -Recurse -Settings ./PSScriptAnalyzerSettings.psd1
Invoke-Pester ./tests
```
