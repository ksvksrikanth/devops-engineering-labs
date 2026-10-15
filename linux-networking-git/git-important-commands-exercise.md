# Git Important Commands Exercise

This exercise walks through the Git commands used most often in day-to-day DevOps work: configuring Git, creating a repository, tracking changes, committing, viewing history, branching, merging, working with remotes, and undoing safe local changes.

Run these commands in a Linux terminal, Git Bash, WSL, or any terminal with Git installed.

## 1. Check Git Version

```bash
# Purpose: Confirm Git is installed and show the installed version.
git --version
```

## 2. Configure Git Identity

Set your username:

```bash
# Purpose: Set the author name used in Git commits.
git config --global user.name "Your Name"
```

Set your email:

```bash
# Purpose: Set the author email used in Git commits.
git config --global user.email "you@example.com"
```

Check the configuration:

```bash
# Purpose: Display active Git configuration values.
git config --list
```

## 3. Create a Practice Repository

Create and enter a new folder:

```bash
# Purpose: Create a new folder for Git practice.
mkdir git-command-lab
# Purpose: Enter the Git practice folder.
cd git-command-lab
```

Initialize Git:

```bash
# Purpose: Initialize the current folder as a Git repository.
git init
```

Check repository status:

```bash
# Purpose: Show the working tree and staging area status.
git status
```

## 4. Create, Stage, and Commit a File

Create a README file:

```bash
# Purpose: Create README.md with an initial heading.
echo "# Git Command Lab" > README.md
```

Check status:

```bash
# Purpose: Check that Git sees README.md as an untracked file.
git status
```

Stage the file:

```bash
# Purpose: Stage README.md so it will be included in the next commit.
git add README.md
```

Commit the file:

```bash
# Purpose: Commit the staged README.md file with a message.
git commit -m "Add README"
```

## 5. View History and Changes

Show commit history:

```bash
# Purpose: Show detailed commit history.
git log
```

Show compact history:

```bash
# Purpose: Show commit history in a compact one-line format.
git log --oneline
```

Modify the README:

```bash
# Purpose: Append another line to README.md.
echo "Practicing important Git commands." >> README.md
```

Show unstaged changes:

```bash
# Purpose: Show unstaged line-by-line changes.
git diff
```

Stage and commit:

```bash
# Purpose: Stage the README.md modification.
git add README.md
# Purpose: Commit the staged README.md update.
git commit -m "Update README notes"
```

## 6. Work with Branches

List branches:

```bash
# Purpose: List local branches.
git branch
```

Create a branch:

```bash
# Purpose: Create a new feature branch without switching to it.
git branch feature/git-notes
```

Switch to the branch:

```bash
# Purpose: Switch to the feature branch.
git checkout feature/git-notes
```

Or create and switch in one command:

```bash
# Purpose: Create a new branch and switch to it immediately.
git checkout -b feature/more-notes
```

Create a file on the branch:

```bash
# Purpose: Create a file while working on the feature branch.
echo "Branch practice notes" > branch-notes.txt
# Purpose: Stage the new branch notes file.
git add branch-notes.txt
# Purpose: Commit the branch notes file.
git commit -m "Add branch notes"
```

## 7. Merge a Branch

Switch back to the main branch:

```bash
# Purpose: Switch back to the main branch before merging.
git checkout main
```

If your default branch is `master`, use:

```bash
# Purpose: Switch back to master if this repository uses master as the default branch.
git checkout master
```

Merge the feature branch:

```bash
# Purpose: Merge the feature branch into the current branch.
git merge feature/more-notes
```

Delete the merged branch:

```bash
# Purpose: Delete the local feature branch after it has been merged.
git branch -d feature/more-notes
```

## 8. Work with Remote Repositories

Show remotes:

```bash
# Purpose: List configured remote repositories.
git remote -v
```

Add a remote repository:

```bash
# Purpose: Connect the local repository to a remote GitHub repository.
git remote add origin https://github.com/YOUR_USERNAME/git-command-lab.git
```

Push the main branch:

```bash
# Purpose: Push the main branch and set origin/main as its upstream.
git push -u origin main
```

Clone an existing repository:

```bash
# Purpose: Copy an existing remote repository to your machine.
git clone https://github.com/YOUR_USERNAME/git-command-lab.git
```

Pull latest changes:

```bash
# Purpose: Fetch and merge the latest changes from the tracked remote branch.
git pull
```

Fetch remote changes without merging:

```bash
# Purpose: Download remote changes without merging them into your current branch.
git fetch
```

## 9. Undo Safe Local Changes

Unstage a staged file:

```bash
# Purpose: Remove README.md from the staging area but keep file changes.
git restore --staged README.md
```

Discard changes in a tracked file:

```bash
# Purpose: Discard local unstaged changes in README.md.
git restore README.md
```

Show files Git is not tracking:

```bash
# Purpose: Show a compact status view.
git status --short
```

Remove an untracked practice file:

```bash
# Purpose: Remove an untracked practice file from the working directory.
rm branch-notes.txt
```

## 10. Useful Daily Commands

```bash
# Purpose: Show current repository status.
git status
# Purpose: Show compact current repository status.
git status --short
# Purpose: Show a visual all-branch commit graph.
git log --oneline --graph --decorate --all
# Purpose: List local branches.
git branch
# Purpose: Show unstaged changes.
git diff
# Purpose: Stage all changed and new files in the current directory.
git add .
# Purpose: Commit staged changes with a clear message.
git commit -m "Your commit message"
# Purpose: Fetch and merge remote changes for the current branch.
git pull
# Purpose: Push local commits to the remote branch.
git push
```

## Cleanup

Move out of the lab folder:

```bash
# Purpose: Move out of the Git practice repository.
cd ..
```

Remove the practice repository only if you no longer need it:

```bash
# Purpose: Remove the local Git practice repository after the lab.
rm -rf git-command-lab
```

Use `rm -rf` carefully. Always confirm the current path with `pwd` before removing directories.

## Safety Notes

- Prefer `git restore` for simple local undo practice.
- Avoid `git reset --hard` until you clearly understand that it discards local changes.
- Avoid force pushing to shared branches.
- Commit small, meaningful changes with clear messages.
