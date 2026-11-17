# Org-wide defaults with `.github`

If you've used an RMM, you already know this idea: set a policy once at the top, and everything underneath inherits it unless it's overridden. In GitHub, two specially named repos do the same job for an organization.

| Repo | Visibility | What it's for |
| --- | --- | --- |
| [`.github`](https://github.com/MSPGC-Demo/.github) | Public | Default issue forms, PR template, policies, workflow templates, shared workflows and the public org profile |
| `.github-private` | Private | The org profile only members can see |

## Default community health files

Put these files in the org's `.github` repo, and every repo in the org that doesn't have its own copy uses them:

- `.github/ISSUE_TEMPLATE/` (issue forms and `config.yml`)
- `PULL_REQUEST_TEMPLATE.md`
- `CONTRIBUTING.md`
- `SECURITY.md`
- `SUPPORT.md`, `CODE_OF_CONDUCT.md` and a few others

A few things to know:

- **The repo's own file always wins.** If `msp-scripts` adds its own `CONTRIBUTING.md`, it stops using the org's.
- **Issue templates have one required location.** Most of these files can sit in the root of the `.github` repo, but issue templates and `config.yml` only work from `.github/ISSUE_TEMPLATE/`. Put them in the root and other repos silently ignore them.
- **Issue templates are all-or-nothing.** If a repo has any template of its own, it stops inheriting the org's templates entirely.
- **Labels must exist everywhere.** If a template applies a label, that label has to exist in the `.github` repo and in every repo that uses the template.
- **Defaults aren't copied into each repo.** You won't see them in a clone. They show up in GitHub's interface: the **New issue** chooser, a new PR's description, and the links on the issue and PR pages.

## Workflow templates

Templates in the `workflow-templates/` folder appear in every repo under **Actions > New workflow**, in a section for workflows from your organization. Each template needs two files:

```
workflow-templates/
├── powershell-ci.yml               # The workflow itself
└── powershell-ci.properties.json   # Name, description and icon shown in the list
```

Write `$default-branch` in a template wherever you'd write `main`. GitHub swaps in the repo's real default branch when someone uses it.

Because this org's `.github` repo is public, its templates are available to every repo in the org. There are limits on templates kept in a private `.github` repo, so check GitHub's documentation for your plan if yours is private.

## Shared (reusable) workflows

A template is copied into a repo once. After that, the copy is on its own. A **reusable workflow** is different: repos call it, so the logic stays in one place.

The shared workflow declares `on: workflow_call`, along with any inputs it accepts:

```yaml
# MSPGC-Demo/.github/.github/workflows/reusable-powershell-ci.yml
on:
  workflow_call:
    inputs:
      fail-on:
        type: string
        default: Warning
```

Each repo calls it with a few lines:

```yaml
jobs:
  ci:
    uses: MSPGC-Demo/.github/.github/workflows/reusable-powershell-ci.yml@main
    with:
      fail-on: Error   # Optional. Overrides the default.
```

The templates in this org combine both ideas: the template is just a short caller, and the real work happens in the shared workflow. New repos start with one click, and they all stay in sync afterwards.

> Calling a shared workflow from a **public** repo is simple. If your `.github` repo is private, you'll also need to allow access under that repo's **Settings > Actions > General > Access**.

## The org profile

- `.github/profile/README.md` is the public landing page for the org.
- `.github-private/profile/README.md` is what **members** see instead. Use it for internal links, onboarding steps and "how we work" notes.

Members can switch between the two with the **Member view / Public view** toggle on the org page.

## Setting this up for your own org

1. Create a public repo called `.github` in your org.
2. Copy the files you want from [MSPGC-Demo/.github](https://github.com/MSPGC-Demo/.github) and change `MSPGC-Demo` to your org name.
3. Optionally, create a private repo called `.github-private` with a `profile/README.md` for members.
4. Create a new repo, click **New issue**, and check that your forms appear.
