# Week 1: Linux Commands and Exercises

This README consolidates the successful commands and exercises captured during the Day 1 and Day 2 Linux practice sessions. Example output is shortened for readability and will vary by machine, user, installed services, and current system state.

## Contents

- [Basic Linux commands exercise](#basic-linux-commands-exercise)
- [Git important commands exercise](#git-important-commands-exercise)
- [Networking important commands exercise](#networking-important-commands-exercise)
- [Process and resource monitoring](#process-and-resource-monitoring)
- [Files and directories](#files-and-directories)
- [Logs and troubleshooting](#logs-and-troubleshooting)
- [Services](#services)
- [Networking](#networking)
- [Users, groups, and permissions](#users-groups-and-permissions)
- [SSH](#ssh)
- [Environment variables and Bash](#environment-variables-and-bash)
- [Practice exercises](#practice-exercises)

## Basic Linux Commands Exercise

See [basic-linux-commands-exercise.md](D:/DevOps-Learning/week1-linux-networking-git/basic-linux-commands-exercise.md) for a beginner command sequence covering:

- Listing files and folders
- Creating and checking a directory
- Changing directories
- Writing and reading `demo.txt`
- Making `demo.txt` read-only with `chmod`
- Using `sudo` and a root shell
- Installing Git with `apt-get`
- Viewing command history and clearing the terminal

## Git Important Commands Exercise

See [git-important-commands-exercise.md](D:/DevOps-Learning/week1-linux-networking-git/git-important-commands-exercise.md) for a focused Git practice lab covering:

- Git version and global identity configuration
- Repository initialization
- `git status`, `git add`, `git commit`, and `git diff`
- Commit history with `git log`
- Branch creation, checkout, merge, and delete
- Remote setup, clone, fetch, pull, and push
- Safe local undo commands with `git restore`

## Networking Important Commands Exercise

See [networking-important-commands-exercise.md](D:/DevOps-Learning/week1-linux-networking-git/networking-important-commands-exercise.md) for a focused networking practice lab covering:

- Hostname, IP address, and route inspection
- Connectivity checks with `ping`
- DNS checks with `nslookup`, `dig`, and `/etc/resolv.conf`
- HTTP checks with `curl`
- Listening ports and active connections with `ss`
- Path tracing with `traceroute` and `tracepath`
- Port checks with `nc`
- Basic firewall inspection with `ufw`

## Process and resource monitoring

### List processes

```bash
ps -ef | head
```

```text
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 16:48 ?        00:00:00 /sbin/init
root           2       1  0 16:48 hvc0     00:00:00 /init
```

Display the parent-child process hierarchy:

```bash
ps -ef --forest
```

```text
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 16:48 ?        00:00:00 /sbin/init
srikanth     741     740  0 17:21 pts/0    00:00:00  \_ bash
```

Search for a process:

```bash
ps -ef | grep docker
```

```text
srikanth    1201     741  0 17:30 pts/0    00:00:00 grep --color=auto docker
```

### Interactive monitoring

```bash
top
```

```text
top - 17:21:52 up 33 min, 1 user, load average: 0.00, 0.00, 0.00
Tasks: 24 total, 1 running, 23 sleeping, 0 stopped, 0 zombie
%Cpu(s): 0.0 us, 0.0 sy, 100.0 id
MiB Mem : 7780.1 total, 7210.2 free, 471.8 used
```

For a more visual interactive monitor:

```bash
htop
```

```text
Tasks: 24, 14 threads; 1 running
Load average: 0.00 0.00 0.00
Uptime: 00:35:19
```

### Memory, disks, and load

```bash
free -h
```

```text
               total        used        free      shared  buff/cache   available
Mem:           7.6Gi       470Mi       7.0Gi       3.5Mi       250Mi       7.1Gi
Swap:          2.0Gi          0B       2.0Gi
```

```bash
df -h
```

```text
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdd       1007G  3.0G  953G   1% /
C:\             210G  165G   45G  79% /mnt/c
```

Check inode consumption:

```bash
df -i
```

```text
Filesystem       Inodes  IUsed     IFree IUse% Mounted on
/dev/sdd       65011712  84321  64927391    1% /
```

```bash
du -sh /var/log
```

```text
115M    /var/log
```

```bash
uptime
```

```text
17:23:36 up 35 min, 1 user, load average: 0.00, 0.00, 0.00
```

Look for out-of-memory events:

```bash
dmesg | grep -i oom
```

```text
# No output means no matching OOM messages were found.
```

### Open files

```bash
lsof | wc -l
```

```text
2147
```

```bash
lsof -i
```

```text
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
sshd      812 root    3u  IPv4  24175      0t0  TCP *:ssh (LISTEN)
```

```bash
lsof -u srikanth | wc -l
```

```text
231
```

## Files and directories

### Navigation and listing

```bash
pwd
cd /var/log
ls -lah
cd ..
cd ~
```

```text
/home/srikanth
total 1.1M
drwxr-xr-x  13 root root 4.0K May 23 17:00 .
drwxr-xr-x  14 root root 4.0K May 23 16:48 ..
```

### Create files and directories

```bash
cd /tmp
mkdir week1
cd week1
touch 1.txt 2.txt 3.txt
echo "DevOps Learning - Week 1" > notes.txt
ls -lah
cat notes.txt
```

```text
total 4.0K
-rw-r--r-- 1 srikanth srikanth  0 May 23 1.txt
-rw-r--r-- 1 srikanth srikanth  0 May 23 2.txt
-rw-r--r-- 1 srikanth srikanth  0 May 23 3.txt
-rw-r--r-- 1 srikanth srikanth 25 May 23 notes.txt
DevOps Learning - Week 1
```

Remove the practice directory after confirming the path:

```bash
cd /tmp
rm -rf week1
```

```text
# rm normally produces no output on success.
```

### Find large directories and files

```bash
du -sh /* 2>/dev/null | sort -hr | head
```

```text
3.0G    /usr
115M    /var
12M     /etc
```

```bash
sudo du -sh /var/* 2>/dev/null | sort -hr | head
```

```text
115M    /var/log
48M     /var/cache
```

```bash
sudo find /var -type f -size +100M
```

```text
/var/log/example-large.log
```

## Logs and troubleshooting

Read an authentication log:

```bash
less /var/log/auth.log
```

`less` opens the file interactively; press `q` to quit.

Follow system journal messages live:

```bash
journalctl -f
```

```text
May 24 10:12:01 host systemd[1]: Started Session 4 of User srikanth.
May 24 10:12:05 host sshd[812]: Server listening on 0.0.0.0 port 22.
```

Show the latest 50 journal messages:

```bash
journalctl -n 50
```

Search system logs for errors:

```bash
grep -i error /var/log/syslog
```

```text
May 24 09:41:10 host app[933]: ERROR unable to connect to service
```

Search for failed SSH logins:

```bash
grep -i "failed" /var/log/auth.log
```

```text
May 24 11:15:30 host sshd[1402]: Failed password for invalid user demo
```

## Services

Check service health:

```bash
systemctl status ssh
```

```text
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled)
     Active: active (running)
```

```bash
systemctl status nginx
```

```text
Unit nginx.service could not be found.
```

Start SSH (requires administrative access):

```bash
sudo systemctl start ssh
```

```text
# systemctl normally produces no output on success.
```

Show queued systemd jobs:

```bash
systemctl list-jobs
```

```text
No jobs running.
```

## Networking

### Addresses and sockets

```bash
ip a
```

```text
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 state UNKNOWN
    inet 127.0.0.1/8 scope host lo
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state UP
    inet 172.20.10.2/20 scope global eth0
```

```bash
ss -tulnp
```

```text
Netid State  Local Address:Port  Peer Address:Port Process
tcp   LISTEN 0.0.0.0:22         0.0.0.0:*         users:(("sshd",pid=812,fd=3))
```

Filter for SSH:

```bash
ss -tulnp | grep 22
```

```text
tcp LISTEN 0.0.0.0:22 0.0.0.0:* users:(("sshd",pid=812,fd=3))
```

### DNS and web connectivity

```bash
nslookup google.com
```

```text
Server:         172.20.0.1
Address:        172.20.0.1#53

Non-authoritative answer:
Name:   google.com
Address: 142.250.183.14
```

```bash
curl https://www.google.com
```

```html
<!doctype html><html>...</html>
```

Trace the network route:

```bash
traceroute google.com
```

```text
traceroute to google.com (142.250.183.14), 30 hops max
 1  gateway (172.20.0.1)  0.521 ms  0.402 ms  0.389 ms
```

> `ss` is the modern replacement for the older `netstat` command on most Linux systems.

## Users, groups, and permissions

### Identity information

```bash
whoami
id
```

```text
srikanth
uid=1000(srikanth) gid=1000(srikanth) groups=1000(srikanth),27(sudo)
```

Inspect account and group databases:

```bash
cat /etc/passwd
cat /etc/group
```

```text
root:x:0:0:root:/root:/bin/bash
srikanth:x:1000:1000:Srikanth:/home/srikanth:/bin/bash
root:x:0:
sudo:x:27:srikanth
```

### Create a user and group

```bash
sudo adduser demo
sudo groupadd devops
sudo usermod -aG devops demo
```

```text
Adding user `demo' ...
Adding new group `demo' (1001) ...
Adding new user `demo' (1001) with group `demo' ...
```

### File permissions and ownership

```bash
touch script.sh
chmod +x script.sh
ls -l script.sh
```

```text
-rwxr-xr-x 1 srikanth srikanth 0 May 24 12:01 script.sh
```

Numeric permissions:

```bash
chmod 755 script.sh
```

```text
# 7 = read/write/execute; 5 = read/execute.
-rwxr-xr-x 1 srikanth srikanth 0 May 24 12:01 script.sh
```

Change ownership:

```bash
sudo chown srikanth:devops script.sh
ls -l script.sh
```

```text
-rwxr-xr-x 1 srikanth devops 0 May 24 12:01 script.sh
```

> Avoid `chmod 777` unless every user genuinely needs write access.

## SSH

Generate a key pair:

```bash
ssh-keygen
```

```text
Generating public/private ed25519 key pair.
Your identification has been saved in /home/srikanth/.ssh/id_ed25519
Your public key has been saved in /home/srikanth/.ssh/id_ed25519.pub
```

Install the public key on another account or host:

```bash
ssh-copy-id srikanth@localhost
```

```text
Number of key(s) added: 1
Now try logging into the machine, with: "ssh 'srikanth@localhost'"
```

## Environment variables and Bash

### Inspect environment variables

```bash
env
echo "$HOME"
echo "$PATH"
```

```text
HOME=/home/srikanth
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
/home/srikanth
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

Set and read a variable:

```bash
export APP_ENV=dev
echo "$APP_ENV"
```

```text
dev
```

Read interactive input:

```bash
read -p "Enter name: " NAME
echo "$NAME"
```

```text
Enter name: Srikanth
Srikanth
```

Use a condition:

```bash
if [ "$NAME" = "Srikanth" ]; then echo "Welcome"; fi
```

```text
Welcome
```

Use a loop:

```bash
for i in 1 2 3; do echo "$i"; done
```

```text
1
2
3
```

Define and call a function:

```bash
greet() { echo "Hello $1"; }
greet Srikanth
```

```text
Hello Srikanth
```

Create and run a script:

```bash
vim hello.sh
chmod +x hello.sh
./hello.sh
```

Example `hello.sh`:

```bash
#!/bin/bash

echo "Hello DevOps"
echo "$APP_ENV"

greet() {
    echo "Hello $1"
}

greet "Srikanth"
```

```text
Hello DevOps
dev
Hello Srikanth
```

## Practice exercises

### 1. Find high-resource processes

Top CPU consumers:

```bash
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head
```

```text
    PID    PPID CMD                         %MEM %CPU
   1642     741 stress --cpu 2               0.1 98.5
```

Top memory consumers:

```bash
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head
```

```text
    PID    PPID CMD                         %MEM %CPU
    255       1 /usr/bin/python3              3.4  0.2
```

### 2. Investigate disk usage

```bash
du -sh /* 2>/dev/null | sort -hr | head
find /var -type f -size +100M
```

Use the first command to rank large top-level directories and the second to locate files larger than 100 MB.

### 3. Count log errors

Create `error-check.sh`:

```bash
#!/bin/bash
LOG_FILE=/var/log/syslog
echo "Checking ERROR count..."
ERROR_COUNT=$(grep -i "error" "$LOG_FILE" | wc -l)
echo "Total ERROR entries: $ERROR_COUNT"
```

```bash
chmod +x error-check.sh
./error-check.sh
```

```text
Checking ERROR count...
Total ERROR entries: 3
```

### 4. Check service health

Create `service-check.sh`:

```bash
#!/bin/bash
SERVICE=ssh
STATUS=$(systemctl is-active "$SERVICE")

if [ "$STATUS" = "active" ]; then
    echo "$SERVICE is healthy"
else
    echo "$SERVICE is NOT healthy"
fi
```

```bash
chmod +x service-check.sh
./service-check.sh
```

```text
ssh is healthy
```

### 5. Investigate open ports

```bash
ss -tulnp
ss -tulnp | grep 22
```

The output maps listening addresses and ports to their processes.

### 6. Select an environment

Create `env-check.sh`:

```bash
#!/bin/bash
if [ "$APP_ENV" = "prod" ]; then
    echo "Running Production Deployment"
else
    echo "Running Development Deployment"
fi
```

```bash
chmod +x env-check.sh
export APP_ENV=prod
./env-check.sh
```

```text
Running Production Deployment
```

### 7. Monitor a process

Create `process-check.sh`:

```bash
#!/bin/bash
PROCESS=nginx

if pgrep -x "$PROCESS" > /dev/null; then
    echo "$PROCESS is running"
else
    echo "$PROCESS is NOT running"
fi
```

```text
nginx is NOT running
```

### 8. Back up logs

Create `backup-logs.sh`:

```bash
#!/bin/bash
BACKUP_DIR=/tmp/log-backup
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/logs.tar.gz" /var/log
echo "Backup completed"
```

```bash
chmod +x backup-logs.sh
sudo ./backup-logs.sh
```

```text
tar: Removing leading `/` from member names
Backup completed
```

### 9. Generate a system report

Create `system-info.sh`:

```bash
#!/bin/bash
echo "===== SYSTEM INFO ====="
echo "Hostname:"
hostname
echo
echo "Memory:"
free -h
echo
echo "Disk:"
df -h
echo
echo "Load Average:"
uptime
```

```text
===== SYSTEM INFO =====
Hostname:
DESKTOP-O3KIF06

Memory:
               total        used        free
Mem:           7.6Gi       470Mi       7.0Gi

Disk:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdd       1007G  3.0G  953G   1% /

Load Average:
17:23:36 up 35 min, 1 user, load average: 0.00, 0.00, 0.00
```

### 10. Investigate failed logins

```bash
grep -i "failed" /var/log/auth.log
```

```text
May 24 11:15:30 host sshd[1402]: Failed password for invalid user demo
```

## Safety notes

- Confirm paths before using recursive deletion commands such as `rm -rf`.
- Prefer a normal `kill PID` before using `kill -9 PID` so a process can shut down cleanly.
- Use `sudo` only for commands that require elevated access.
- Outputs shown here are examples; process IDs, addresses, sizes, timestamps, and service states change between systems.
