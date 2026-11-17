# Issues, pull requests and Projects

GitHub already has most of the pieces an MSP uses to run service work. They just have different names.

| In your MSP | In GitHub |
| --- | --- |
| Ticket | Issue |
| Ticket intake form | Issue form |
| Change request and approval | Pull request and review |
| Service or dispatch board | Project |
| "Resolved by change #123" note | `Closes #123` in a pull request |

## Issues

An issue is a ticket for your code: a bug, a request or a chore.

- Click **New issue** to see the forms. The forms in this repo come from the org's [`.github`](https://github.com/MSPGC-Demo/.github) repo, so every repo in the org asks for the same details.
- Use **labels** to sort issues (`bug`, `enhancement`) and **assignees** to show who owns them.
- Mention a teammate with `@username` to pull them in.

From the command line:

```powershell
gh issue list
gh issue create
gh issue view 1
```

## From issue to branch

On an issue's page, open **Development** in the right sidebar and choose **Create a branch**. The branch is linked to the issue automatically. You can do the same from the command line:

```powershell
gh issue develop 1 --checkout
```

## Pull requests

A pull request asks to merge your branch into `main`. It's where changes get checked and reviewed before they reach anything that matters.

1. Push your branch and open the PR (`gh pr create`). The [PR template](https://github.com/MSPGC-Demo/.github/blob/main/PULL_REQUEST_TEMPLATE.md) fills in the description for you.
2. Add `Closes #1` to the description. When the PR merges, issue #1 closes on its own.
3. **Checks** run automatically. A red X means something failed. Click **Details** to see what.
4. A reviewer reads the **Files changed** tab. They can comment on specific lines, suggest edits you can apply with one click, approve, or request changes.
5. Once checks pass and the review is done, choose **Squash and merge**, then delete the branch.

> **Squash and merge** combines all of a PR's commits into one tidy commit on `main`. It's a good default for small teams.

## Protecting `main`

In this repo, `main` is protected by a **ruleset** (**Settings > Rules > Rulesets**):

- Every change has to come through a pull request.
- The lint and test checks must pass before the merge button unlocks.

This is how you guarantee nothing reaches your RMM without going through the process, even on a busy Friday afternoon.

## Projects

A Project is a board (or table) that tracks issues and pull requests across one or more repos, just like a service board.

- Columns come from the **Status** field: Todo, In progress, Done.
- Built-in workflows move cards for you. Closing an issue or merging a PR moves its card to **Done**.
- You can add your own fields, such as Client, Priority or Estimate, and filter or group by them.

Create one from the org's **Projects** tab, then add issues to it from the issue sidebar or the board itself.

## Next

[GitHub Actions for scripts](03-github-actions.md)
