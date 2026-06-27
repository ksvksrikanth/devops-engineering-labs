# Basic Linux Commands Exercise

This exercise walks through common Linux shell tasks: listing files, creating and navigating directories, writing and reading files, changing permissions, using elevated access, installing Git, reviewing command history, and clearing the terminal.

Run these commands in a Linux terminal such as Ubuntu, WSL, or an EC2 Linux instance.

## 1. List Files and Folders

Show the current directory:

```bash
# Purpose: Print the full path of the current working directory.
pwd
```

List files and folders:

```bash
# Purpose: List visible files and folders in the current directory.
ls
```

List files with details, including hidden files:

```bash
# Purpose: List all files with permissions, owner, size, and timestamp details.
ls -la
```

## 2. Create a New Directory

Create a practice directory:

```bash
# Purpose: Create a new practice directory in the current folder.
mkdir linux-command-lab
```

Check that the directory was created:

```bash
# Purpose: Confirm that the new directory appears in the current folder.
ls -la
```

## 3. Navigate to a Specific Directory

Move into the new directory:

```bash
# Purpose: Change the current directory to the practice directory.
cd linux-command-lab
```

Confirm the current location:

```bash
# Purpose: Confirm that the shell is now inside the practice directory.
pwd
```

Move back to the parent directory:

```bash
# Purpose: Move one level up to the parent directory.
cd ..
```

Move into the practice directory again:

```bash
# Purpose: Return to the practice directory.
cd linux-command-lab
```

## 4. Write and Display Text in a File

Create `demo.txt` with one line of text:

```bash
# Purpose: Create demo.txt and write the first line into it.
echo "This is my first Linux command exercise." > demo.txt
```

Append another line:

```bash
# Purpose: Append a second line to demo.txt without replacing existing content.
echo "I am practicing file, folder, and permission commands." >> demo.txt
```

Display the file content:

```bash
# Purpose: Display the full content of demo.txt.
cat demo.txt
```

## 5. Change `demo.txt` to Read Only

Make the file read-only for everyone:

```bash
# Purpose: Make demo.txt read-only for owner, group, and others.
chmod 444 demo.txt
```

Check the permission mode:

```bash
# Purpose: Verify the file permission mode after chmod.
ls -l demo.txt
```

Expected permission pattern:

```text
-r--r--r--
```

Try appending text:

```bash
# Purpose: Test that write access is blocked for a read-only file.
echo "test" >> demo.txt
```

A normal user should receive a permission error. Restore write access when finished:

```bash
# Purpose: Restore normal owner write permission on demo.txt.
chmod 644 demo.txt
```

## 6. Change to Superuser or Root User

Run one command with elevated privileges:

```bash
# Purpose: Run a single command with superuser privileges and print that user.
sudo whoami
```

Expected output:

```text
root
```

Open a root shell only when you intentionally need it:

```bash
# Purpose: Start an interactive root shell when elevated access is required.
sudo -i
```

Check the current user:

```bash
# Purpose: Confirm which user is active in the current shell.
whoami
```

Exit the root shell:

```bash
# Purpose: Leave the root shell and return to the previous user.
exit
```

## 7. Install Git with `apt`

Update package metadata:

```bash
# Purpose: Refresh the local apt package index before installing software.
sudo apt-get update
```

Install Git:

```bash
# Purpose: Install Git with apt without interactive confirmation prompts.
sudo apt-get install -y git
```

Verify Git:

```bash
# Purpose: Confirm that Git is installed and print its version.
git --version
```

## 8. List Command History and Clear the Terminal

Show previously used commands:

```bash
# Purpose: Show the previously executed shell commands.
history
```

Show only the latest 20 commands:

```bash
# Purpose: Show only the most recent 20 commands from shell history.
history | tail -20
```

Clear the terminal screen:

```bash
# Purpose: Clear the terminal screen.
clear
```

Keyboard shortcut:

```text
Ctrl + L
```

## Cleanup

From inside `linux-command-lab`, move out and remove the practice directory:

```bash
# Purpose: Move out of the practice directory.
cd ..
# Purpose: Remove the practice directory and its files after the lab.
rm -rf linux-command-lab
```

Use `rm -rf` carefully. Always confirm the current path with `pwd` before removing directories.
