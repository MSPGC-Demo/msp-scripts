# Cheat sheet

## Getting started

| Command | What it does |
| --- | --- |
| `gh auth login` | Sign in to GitHub |
| `gh repo clone OWNER/REPO` | Download a repo |
| `gh repo fork OWNER/REPO --clone` | Make your own copy of a repo and download it |

## Everyday git

| Command | What it does |
| --- | --- |
| `git status` | What's changed, and what's staged |
| `git diff` | Show the exact changes |
| `git switch main` then `git pull` | Get the latest `main` |
| `git switch -c feature/name` | Create a branch and switch to it |
| `git add <file>` | Stage a file for the next commit |
| `git commit -m "Message"` | Save a snapshot |
| `git push -u origin feature/name` | Send a new branch to GitHub |
| `git push` | Send more commits on a branch you've already pushed |
| `git log --oneline` | Short history |

## Undo

| Command | What it does |
| --- | --- |
| `git restore <file>` | Discard uncommitted changes to a file (permanent) |
| `git restore --staged <file>` | Un-stage a file |
| `git commit --amend -m "Message"` | Fix the last commit message (before pushing) |
| `git reset --soft HEAD~1` | Undo the last commit and keep its changes (before pushing) |
| `git revert <commit-id>` | Reverse a commit that's already pushed |

## Issues and pull requests

| Command | What it does |
| --- | --- |
| `gh issue list` | List open issues |
| `gh issue create` | Open an issue |
| `gh issue develop 12 --checkout` | Create a branch linked to issue #12 and switch to it |
| `gh pr create --fill` | Open a PR from your branch |
| `gh pr checks` | See check results for your PR |
| `gh pr merge --squash --delete-branch` | Merge the PR and clean up |

## Releases

| Command | What it does |
| --- | --- |
| `git tag v1.2.0` then `git push origin v1.2.0` | Publish a release (the release workflow does the rest) |
| `gh release list` | List releases |

## Linking keywords

Put one of these in a pull request description to close the issue when the PR merges:

`Closes #12` · `Fixes #12` · `Resolves #12`
