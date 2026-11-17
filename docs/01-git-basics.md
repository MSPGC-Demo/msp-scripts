# Git basics

Git keeps the full history of a folder: every change, who made it, when, and why. GitHub hosts that folder online so your team can share it, review changes and automate around it.

## The words you'll hear

| Term | What it means |
| --- | --- |
| **Repository (repo)** | A folder that git tracks, plus its complete history |
| **Commit** | A saved snapshot of your changes with a short note explaining them, like a time entry on a ticket |
| **Branch** | A separate line of work. You change things on a branch so `main`, the version everyone relies on, stays safe until your change is reviewed. |
| **Remote** | The copy of the repo on GitHub, usually called `origin` |
| **Clone** | Download a repo and its history to your computer |
| **Push / pull** | Send your commits to GitHub / bring other people's commits down |
| **Pull request (PR)** | A request to merge your branch into `main`, where it gets checked and reviewed |

## One-time setup

Install the tools (Windows):

```powershell
winget install --id Git.Git -e
winget install --id GitHub.cli -e
winget install --id Microsoft.VisualStudioCode -e
```

Tell git who you are, then sign in to GitHub:

```powershell
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
gh auth login
```

> **Tip:** To keep your email address private, use the `noreply` address GitHub gives you under **Settings > Emails**.

## The everyday loop

Want to practice with this repo? Fork it first so you have your own copy you can push to:

```powershell
gh repo fork MSPGC-Demo/msp-scripts --clone
cd msp-scripts
```

Then this is the loop you'll repeat for every change:

```powershell
# 1. Start from an up-to-date main
git switch main
git pull

# 2. Create a branch for your change
git switch -c feature/csv-export

# 3. Edit files, then see what changed
git status
git diff

# 4. Stage and commit
git add scripts/Get-DiskSpaceReport.ps1
git commit -m "Add CSV export option"

# 5. Push the branch and open a pull request
git push -u origin feature/csv-export
gh pr create --fill
```

After the pull request merges, clean up:

```powershell
git switch main
git pull
git branch -d feature/csv-export
```

## Writing good commit messages

Write the message as what the commit does, in a few words:

- Good: `Add CSV export option`, `Fix percent free for zero-size disks`
- Not useful: `updates`, `fixed it`, `asdf`

Six months from now, these messages are how someone (probably you) works out why a line changed.

## When something goes wrong

| Situation | What to run |
| --- | --- |
| Throw away changes to a file you haven't committed | `git restore <file>` (this permanently discards those edits) |
| Un-stage a file you added by mistake | `git restore --staged <file>` |
| Fix the message on your last commit (not pushed yet) | `git commit --amend -m "Better message"` |
| Undo your last commit but keep the changes (not pushed yet) | `git reset --soft HEAD~1` |
| Undo a commit that's already pushed | `git revert <commit-id>` (adds a new commit that reverses it) |
| You committed to `main` by mistake (not pushed yet) | `git branch feature/my-fix` to save your work on a branch, then `git reset --hard origin/main` to move `main` back |

Two rules keep you out of real trouble:

1. **Never force-push a branch other people use.** It rewrites history under them.
2. **Never commit secrets.** If one slips through, rotate it right away. See the org [security policy](https://github.com/MSPGC-Demo/.github/blob/main/SECURITY.md).

## Next

[Issues, pull requests and Projects](02-issues-prs-projects.md)
