# Day 1 - Linux Fundamentals

## Why Linux Matters in DevOps

Linux is the operational backbone of modern infrastructure.

Most DevOps tools and platforms run on Linux:

- CI/CD runners
- Docker containers
- Kubernetes clusters
- Cloud virtual machines
- Monitoring systems
- Automation servers

### Important Point
> Kubernetes itself is Linux-centric.

---

# Linux Mental Model

Linux is built around:

- Files
- Processes
- Permissions
- Networking
- Services

## Core Linux Philosophy

> In Linux, almost everything is treated like a file.

Examples:

| Resource | Linux Representation |
|---|---|
| Hard disk | File/device |
| Logs | Files |
| Process information | `/proc` |
| Devices | Files |
| Network sockets | Files |

---

# Linux Architecture

```text
Applications
    ↓
Shell (Bash)
    ↓
Linux Kernel
    ↓
Hardware
```

## Components

| Component | Purpose |
|---|---|
| Kernel | Core OS engine |
| Shell | Command interpreter |
| Filesystem | Data organization |
| Processes | Running programs |
| systemd | Service manager |
| Networking Stack | Communication |

---

# Important Linux Concepts

## Process

A running program.

Examples:

- nginx
- java
- tomcat
- docker

## Service

A background managed process.

Examples:

- sshd
- nginx
- docker

## Filesystem

Storage structure used by Linux.

## Permissions

Controls security and access.

---

# Process Lifecycle

```text
Program on Disk
      ↓
Executed
      ↓
Running Process
      ↓
Uses CPU + Memory
      ↓
Terminates
```

## Zombie Process

A dead process that has completed execution but still exists because the parent process has not cleaned it.

---

# Essential Linux Directories

Linux starts from:

```bash
/
```

This is called the:

> Root Filesystem

## Important Directories

| Directory | Purpose |
|---|---|
| `/home` | User files |
| `/etc` | Configuration files |
| `/var/log` | System and application logs |
| `/tmp` | Temporary files |
| `/bin` | Essential commands |
| `/proc` | Process/kernel information |
| `/dev` | Device files |
| `/opt` | Optional software |
| `/usr` | User binaries/libraries |
| `/sbin` | System administration binaries |

---

# Important DevOps Files

## DNS Configuration

```bash
/etc/resolv.conf
```

## Hosts File

```bash
/etc/hosts
```

Used for:

- Local hostname mapping
- Internal testing
- DNS overrides

## User Accounts

```bash
/etc/passwd
```

## Filesystem Mounts

```bash
/etc/fstab
```

---

# Understanding /proc

`/proc` is a virtual filesystem.

> These are not real files on disk.

Used for kernel and process information.

## Examples

### CPU Information

```bash
/proc/cpuinfo
```

### Memory Information

```bash
/proc/meminfo
```

### Process Information

```bash
/proc/<PID>
```

Example:

```bash
/proc/1234
```

---

# Basic Linux Commands

## 1. Check Current Shell

```bash
echo $SHELL
```

Example Output:

```bash
/bin/bash
```

---

## 2. Print Text

```bash
echo "Hello DevOps"
```

---

## 3. List Files

```bash
ls
```

Detailed format:

```bash
ls -lah
```

### Important Flags

| Option | Meaning |
|---|---|
| `-l` | Long format |
| `-a` | Hidden files |
| `-h` | Human readable |

---

## 4. Present Working Directory

```bash
pwd
```

Displays current directory.

---

## 5. Change Directory

```bash
cd /var/log
```

Go back:

```bash
cd ..
```

Go to home:

```bash
cd ~
```

---

# Directory Operations

## Create Directory

```bash
mkdir new-directory
```

## Create Nested Directories

```bash
mkdir -p /tmp/asia/india/bangalore
```

## Remove Directory

```bash
rm -r mydir
```

⚠️ Be careful with recursive delete.

---

# File Operations

## Create File

```bash
touch newfile.txt
```

## Add Content to File

```bash
cat > newfile.txt
```

Press:

```text
CTRL + D
```

To save and exit.

---

## View File Content

```bash
cat newfile.txt
```

---

## Copy File

```bash
cp newfile.txt copy-file.txt
```

## Copy Directory

```bash
cp -r mydir /tmp/my-dir
```

---

## Move or Rename File

```bash
mv old.txt new.txt
```

---

## Delete File

```bash
rm file.txt
```

## Delete Directory Recursively

```bash
rm -rf folder
```

## Important Production Warning

⚠️ `rm -rf` is extremely dangerous.

Always verify:

- Current path
- Target directory
- Environment (Dev/Test/Prod)

---

# Viewing File Content

## Entire File

```bash
cat file.txt
```

---

## Large Files

```bash
less file.txt
```

Quit:

```bash
q
```

---

## First Lines

```bash
head file.txt
```

---

## Last Lines

```bash
tail file.txt
```

---

## Live Log Monitoring

```bash
tail -f app.log
```

## Common Use Cases

- Application debugging
- Production incidents
- Deployment monitoring
- Kubernetes pod logs

### Real Example

```bash
tail -f /var/log/syslog
```

---

# grep - Search Inside Files

## Search Text

```bash
grep ERROR app.log
```

## Case Insensitive Search

```bash
grep -i error app.log
```

## Recursive Search

```bash
grep -r database /etc
```

## Common DevOps Use Cases

- Log analysis
- Troubleshooting
- CI/CD debugging
- Monitoring analysis

---

# Process Management

## View Processes

```bash
ps -ef
```

### Meaning

| Option | Meaning |
|---|---|
| `-e` | All processes |
| `-f` | Full format |

### Displays

- User
- PID
- Parent PID
- Start time
- Command

---

## Difference Between ps -ef and ps aux

| Command | Style |
|---|---|
| `ps -ef` | UNIX style options |
| `ps aux` | BSD style options |

Both show process information.

---

## Filter Processes

### Find nginx Process

```bash
ps -ef | grep nginx
```

### Find Java Process

```bash
ps -ef | grep java
```

### Find Kubernetes Related Processes

```bash
ps -ef | grep kube
```

---

## Process Tree

```bash
pstree
```

Shows:

- Parent-child hierarchy
- Process relationships

---

# Real-Time Monitoring

## top

```bash
top
```

## htop

```bash
htop
```

`htop` is an improved interactive version.

---

# Important Monitoring Metrics

| Metric | Meaning |
|---|---|
| CPU | Processor usage |
| MEM | Memory usage |
| PID | Process ID |
| USER | Process owner |

---

# Kill Processes

## Graceful Kill

```bash
kill PID
```

Example:

```bash
kill 1234
```

---

## Force Kill

```bash
kill -9 PID
```

Example:

```bash
kill -9 1234
```

⚠️ Dangerous command.

### Why?

Because cleanup may fail:

- Data corruption possible
- Connections may break
- Transactions may fail
- Graceful shutdown skipped

---

# CPU vs Memory Understanding

# CPU

CPU measures active computation.

## High CPU Indicates

- Infinite loops
- Heavy calculations
- Excessive threads

## Symptoms

- System becomes slow
- High load average

---

# Memory

Memory stores process data in RAM.

## High Memory Usage Indicates

- Memory leaks
- Heavy caching
- Large datasets
- Inefficient applications

## Possible Outcomes

- OOM kills
- Crashes
- Memory exhaustion

---

# Memory and Disk Commands

## Memory Usage

```bash
free -h
```

Shows:

- Total
- Used
- Free
- Available

---

## Disk Usage

```bash
df -h
```

Checks mounted filesystems.

---

## Directory Size

```bash
du -sh *
```

---

## System Load

```bash
uptime
```

## Important Note

Load average:

> Runnable/waiting processes over time

It is NOT CPU percentage.

---

# Linux Troubleshooting Flow

```text
Symptom
   ↓
Observe
   ↓
Identify failing layer
   ↓
Check logs
   ↓
Validate resources
   ↓
Find root cause
   ↓
Fix safely
```

---

# Logs and Troubleshooting

## Important Log Files

| File | Purpose |
|---|---|
| `/var/log/syslog` | System logs |
| `/var/log/auth.log` | Authentication logs |
| `/var/log/kern.log` | Kernel logs |

---

## View Logs

```bash
less /var/log/syslog
```

## Search Errors

```bash
grep ERROR /var/log/syslog
```

---

# journalctl (VERY Important)

Modern Linux systems use:

> systemd journal

## View Logs

```bash
journalctl
```

## Last 50 Logs

```bash
journalctl -n 50
```

## Live Logs

```bash
journalctl -f
```

## Service Specific Logs

```bash
journalctl -u ssh
```

## Why journalctl Matters

Heavily used in:

- Linux servers
- Kubernetes nodes
- Cloud VMs
- CI/CD runners

---

# Networking Commands

## Check IP Address

```bash
ip a
```

---

## DNS Test

```bash
nslookup google.com
```

---

## Connectivity Test

```bash
ping google.com
```

---

## Check Open Ports

```bash
ss -tulnp
```

### Why Important?

Used to:

- Verify listening services
- Check open ports
- Troubleshoot connectivity

---

# ss vs netstat

Modern Linux prefers:

```bash
ss
```

Instead of:

```bash
netstat
```

## Why?

- Faster
- More efficient
- Better socket inspection

---

# Linux Permissions

## View Permissions

```bash
ls -l
```

Example:

```text
-rwxr-xr--
```

## Permission Breakdown

| Symbol | Meaning |
|---|---|
| r | Read |
| w | Write |
| x | Execute |

## Structure

```text
Owner | Group | Others
```

---

## Change Permission

```bash
chmod +x script.sh
```

Makes script executable.

---

## Change Ownership

```bash
chown user:user file.txt
```

---

# User Management

## Current User

```bash
whoami
```

---

## User Details

```bash
id
```

Shows:

- UID
- GID
- Groups

---

## Switch User

```bash
su username
```

---

## SSH Login

```bash
ssh username@<ip-address>
```

Example:

```bash
ssh devops@192.168.1.10
```

---

# sudo

Used for elevated privileges.

Example:

```bash
sudo ls /root
```

Configuration file:

```bash
/etc/sudoers
```

---

# Download Files

## curl

```bash
curl URL -O
```

Example:

```bash
curl https://example.com/file.zip -O
```

---

## wget

```bash
wget URL -O filename
```

Example:

```bash
wget https://example.com/file.zip -O app.zip
```

---

# VI / VIM Editor Basics

## Open File

```bash
vi file.txt
```

---

# Modes in VI

## Command Mode

Default mode.

Used for:

- Navigation
- Copy
- Delete

---

## Insert Mode

Press:

```bash
i
```

Used to:

- Add content
- Modify content

Exit insert mode:

```bash
ESC
```

---

# Delete Operations

## Delete Character

```bash
x
```

## Delete Line

```bash
dd
```

---

# Copy and Paste in VI

## Copy Line

```bash
yy
```

## Paste

```bash
p
```

---

# Save and Quit

## Save

```bash
:w
```

## Quit Without Saving

```bash
:q!
```

## Save and Exit

```bash
:wq
```

---

# Search Text in VI

## Search Word

```bash
/of
```

Highlights occurrences in file.

---

# DevOps Operational Mindset

As a DevOps engineer always ask:

| Question | Why |
|---|---|
| Is process running? | Service health |
| CPU high? | Performance/scaling issue |
| Memory leaking? | Application issue |
| Disk full? | Operational issue |
| Logs showing errors? | Root cause analysis |
| Port listening? | Connectivity issue |

---

# Troubleshooting Order (VERY Important)

Always investigate in this order:

```text
Infrastructure
   ↓
Operating System
   ↓
Network
   ↓
Application
   ↓
Dependencies (DB/API/Cache)
```

---

# Mini Hands-On Practice

## Exercise 1

```bash
cd /tmp
mkdir week1
cd week1
touch file1.txt file2.txt file3.txt
```

---

## Exercise 2

```bash
ls -lah
```

---

## Exercise 3

```bash
echo "DevOps Learning" > notes.txt
cat notes.txt
```

---

## Exercise 4

Open another terminal and run:

```bash
top
```

Observe:

- CPU
- Memory
- Processes

---

## Exercise 5

```bash
tail -f /var/log/syslog
```

Observe live logs.

---

# Interview Questions

## Scenario 1

Production Linux server suddenly becomes slow.

### What should you check?

- CPU usage
- Memory usage
- Disk usage
- Running processes
- Logs
- Network latency

Commands:

```bash
top
free -h
df -h
ps -ef
journalctl -f
```

---

## Scenario 2

Application team says server has memory issue.

### First Checks

```bash
free -h
ps -ef
htop
```

Look for:

- High memory processes
- Memory leaks
- OOM kills

---

## Scenario 3

Disk usage reached 100%.

### Troubleshooting Steps

```bash
df -h
du -sh *
```

Check:

- Large logs
- Old backups
- Temporary files

---

# Important Commands to Memorize

```bash
ps -ef
top
htop
tail -f
grep
journalctl
ss -tulnp
free -h
df -h
ip a
```

---

# Key Takeaways

- Linux is foundational to DevOps.
- Logs are the first place to check during incidents.
- Learn process monitoring deeply.
- Understand permissions carefully.
- Networking basics are mandatory.
- Troubleshooting mindset matters more than memorizing commands.

---

# Suggested Practice for Tomorrow

Practice these repeatedly:

- File operations
- Process monitoring
- Log analysis
- Permissions
- Networking commands
- VI editor

The goal is:

> Become comfortable operating Linux without fear.

---

## Reference Notes

Prepared using uploaded Linux notes and command practice sessions. fileciteturn0file0 fileciteturn0file1 fileciteturn0file2

