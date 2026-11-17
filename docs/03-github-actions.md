# GitHub Actions for scripts

**GitHub Actions** runs tasks for you when something happens in a repo, such as a pull request being opened or a tag being pushed.

- **CI (continuous integration)** checks every change automatically. Here, that means linting with PSScriptAnalyzer and testing with Pester.
- **CD (continuous delivery)** ships changes automatically. Here, that means packaging the scripts into a release your RMM can download.

## How a workflow is built

A workflow is a YAML file in `.github/workflows/`. It has three parts:

```yaml
name: PowerShell CI          # What it's called in the Actions tab

on:                          # When it runs
  pull_request:
  push:
    branches: [ main ]

jobs:                        # What it does
  ci:
    uses: MSPGC-Demo/.github/.github/workflows/reusable-powershell-ci.yml@main
```

This repo's workflows are short because they call **shared workflows** from the org's [`.github`](https://github.com/MSPGC-Demo/.github) repo. Every repo in the org gets the same checks, and fixing the shared workflow fixes it everywhere. See [Org-wide defaults](04-org-defaults.md) for how that works.

## What runs, and when

| Workflow | Runs when | What it does |
| --- | --- | --- |
| [`ci.yml`](../.github/workflows/ci.yml) | A pull request is opened or updated, or something is pushed to `main` | Lints every script with PSScriptAnalyzer and runs the Pester tests in `tests/` |
| [`release.yml`](../.github/workflows/release.yml) | A tag starting with `v` is pushed, like `v1.2.0` | Zips `scripts/`, writes a SHA-256 checksum, and publishes both as a GitHub release |

## Reading a failed check

When a check fails on a pull request:

1. Scroll to the checks at the bottom of the PR and click **Details** next to the red X.
2. The job **summary** lists every problem in a table.
3. Open the **Files changed** tab. Each lint problem appears inline on the line that caused it.
4. Fix it, commit and push. The checks run again on their own.

You can run the same checks before you push. See [Run the checks locally](../README.md#run-the-checks-locally).

## Publishing a release

Releases come from tags. Once your change is merged:

```powershell
git switch main
git pull
git tag v1.1.0
git push origin v1.1.0
```

Within a minute or so, the release appears under **Releases** with `msp-scripts.zip` and `msp-scripts.zip.sha256` attached.

Use [semantic versioning](https://semver.org): bump the first number for changes that break existing usage, the second for new features, and the third for fixes.

## Downloading a release from your RMM

The file names never change, so this URL always points at the newest release:

```
https://github.com/MSPGC-Demo/msp-scripts/releases/latest/download/msp-scripts.zip
```

This snippet downloads the zip, checks it against the published checksum, and only extracts it if they match. It works in Windows PowerShell 5.1 and PowerShell 7.

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$base = 'https://github.com/MSPGC-Demo/msp-scripts/releases/latest/download'
$zip  = Join-Path $env:TEMP 'msp-scripts.zip'
$dest = 'C:\ProgramData\MSPScripts'

Invoke-WebRequest "$base/msp-scripts.zip"        -OutFile $zip         -UseBasicParsing
Invoke-WebRequest "$base/msp-scripts.zip.sha256" -OutFile "$zip.sha256" -UseBasicParsing

$expected = (Get-Content "$zip.sha256" -Raw).Split(' ')[0].Trim()
$actual   = (Get-FileHash $zip -Algorithm SHA256).Hash

if ($actual -ne $expected) {
    throw "Checksum mismatch. Expected $expected but got $actual. Not extracting."
}

Expand-Archive $zip -DestinationPath $dest -Force
```

## Secrets

If a workflow needs a password or API key, store it under **Settings > Secrets and variables > Actions** and use it as `${{ secrets.NAME }}`. GitHub hides secret values in logs. Never put them in the workflow file itself.

## Pinning shared workflows

This repo calls the shared workflows at `@main`, so it always gets the latest version. That's simple, and fine while one team owns everything. If a bad change to a shared workflow would hurt you, tag the `.github` repo (for example `v1`) and call `@v1` instead. Then updates only arrive when you move the tag.

## Next

[Org-wide defaults with `.github`](04-org-defaults.md)
