# Day 4: I/O Redirection, Environment Variables, rsync & Linux Q&A Revision Bank

**Date:** Oct 05  
**Topic:** Standard I/O Redirection (`>`, `>>`, `2>`, `&>`), Environment Variables, Shell Special Variables, `rsync` file synchronization, and 58 Linux Interview/Class Q&A.

---

## 1. I/O Redirection Commands

Every Linux process opens three default data streams:
* `0` (Standard Input - `stdin`) : Default keyboard
* `1` (Standard Output - `stdout`) : Default terminal screen
* `2` (Standard Error - `stderr`) : Default terminal screen for errors

| Syntax / Command | Description | Practical Example |
| :--- | :--- | :--- |
| `cmd < file` | Take standard input (`stdin`) from a file. | `mysql -u root -p database_name < backup.sql` |
| `cmd > file` | Redirect `stdout` to a file (overwrites existing content). | `uptime > system_status.txt` |
| `cmd >> file` | Append `stdout` to the end of a file. | `echo "Run at $(date)" >> app.log` |
| `cmd 2> file` | Redirect `stderr` (error messages only) to a file. | `ls /nonexistent_dir 2> error.log` |
| `cmd 2>&1` | Redirect `stderr` to the same stream as `stdout`. | `find / -name "*.conf" > results.txt 2>&1` |
| `cmd &> file` | Redirect both `stdout` and `stderr` to a single file. | `./deploy_script.sh &> deploy.log` |
| `cmd 1>&2` | Redirect `stdout` to the `stderr` stream. | `echo "Error: invalid input" 1>&2` |
| `cmd > /dev/null` | Discard `stdout` (send output to null blackhole device). | `ping -c 1 8.8.8.8 > /dev/null` |
| `cmd &> /dev/null` | Discard all output (both stdout and stderr). | `crontab_job.sh &> /dev/null` |
| `cmd1 <(cmd2)` | Process Substitution: Use output of `cmd2` as temporary file input for `cmd1`. | `diff <(ls dir1) <(ls dir2)` |

---

## 2. Environment Variables & Commands

Environment variables store system-wide or user-level configuration settings accessible by child processes and shell scripts.

| Command | Description | Example |
| :--- | :--- | :--- |
| `export VAR=value` | Set and export an environment variable for current shell & child processes. | `export APP_ENV=production`<br>`export PORT=8080` |
| `echo $VAR` | Display the value of a specific variable. | `echo $APP_ENV`<br>`echo $PATH` |
| `env` | List all exported environment variables in current session. | `env` |
| `printenv` | Print all or specific environment variable values. | `printenv HOME`<br>`printenv USER` |
| `unset VAR` | Delete / remove an environment variable. | `unset APP_ENV` |
| `export -p` | Display list of all exported variables formatted as shell commands. | `export -p` |
| `env VAR=value CMD` | Pass a variable temporarily to a single command without modifying shell. | `env NODE_ENV=development npm start` |

---

## 3. Shell Special Variables

Variables automatically maintained by the shell during script execution:

| Variable | Description |
| :--- | :--- |
| `$0` | The name of the script being executed. |
| `$1, $2, $3...` | Command-line arguments passed to the script (`$1` = 1st arg, `$2` = 2nd arg). |
| `$#` | Total number of positional arguments passed to the script. |
| `$@` | All command-line arguments provided as separate quoted words (`"$1" "$2"`). |
| `$*` | All command-line arguments combined into a single string (`"$1 $2"`). |
| `$?` | Exit status code of the last executed command (`0` = Success, `Non-zero` = Error). |
| `$$` | Process ID (PID) of current running shell script. |

---

## 4. File Synchronization with `rsync`

`rsync` (Remote Sync) efficiently copies and synchronizes files locally or across network hosts by transferring only changed chunks (delta transfer algorithm).

**Basic Syntax:** `rsync [options] <SOURCE> <DESTINATION>`

### Key Options:
* `-a` (Archive) : Preserves permissions, timestamps, owner/group, and symlinks.
* `-v` (Verbose) : Displays detailed transfer logs.
* `-z` (Compress) : Compresses data during network transit.
* `-r` (Recursive) : Copies subdirectories recursively.
* `-u` (Update) : Skips files that are already newer in the destination.
* `-n` / `--dry-run` : Runs simulation without performing actual copying.
* `-e` : Specifies remote shell protocol (e.g., `-e ssh`).
* `--delete` : Deletes files in destination that no longer exist in source (exact mirror).
* `-P` : Combines `--progress` (shows transfer speed & ETA) and `--partial` (resumes interrupted transfers).

### Practical Examples:
```bash
# Local backup of a directory with attributes preserved
rsync -av /var/www/html/ /backup/html_backup/

# Dry run test before actual sync
rsync -av --dry-run /var/www/html/ /backup/html_backup/

# Remote sync over SSH to EC2 server
rsync -avz -e "ssh -i ~/.ssh/devops-key.pem" ./build/ ubuntu@54.210.10.20:/var/www/app/

# Mirror source to destination (delete extra files in destination)
rsync -av --delete /data/projects/ /backup/projects/
```

---

## 5. Linux Class & Technical Q&A Bank (Questions 1 – 58)

### General & Navigation Basics
* **Q1: What is the use of `echo` command?**  
  `echo` outputs text/strings passed to it as arguments (e.g., `echo "Hello World"`).
* **Q2: How to check hostname in Linux?**  
  `hostname` or `hostname -I` (for IP).
* **Q3: How to check name of current logged-in user?**  
  `whoami` or `id`.
* **Q4: How to check current working directory?**  
  `pwd` (Print Working Directory).
* **Q4b: How to see all users in Linux?**  
  `cut -d: -f1 /etc/passwd`
* **Q5: Difference between relative and absolute path?**  
  * **Absolute path:** Starts from the root directory `/` (e.g., `/var/log/nginx/access.log`).
  * **Relative path:** Starts from current working directory (e.g., `./logs/access.log` or `../config`).

### File Management & Viewing
* **Q6: Which commands create a file in Linux?**  
  `touch`, `vi`, `vim`, `nano`, or redirection `echo "" > file.txt`.
* **Q7: How to edit an existing file on a Linux server?**  
  Using terminal text editors like `vim`, `vi`, or `nano`.
* **Q8: How to rename a file in Linux?**  
  Using the `mv` command (e.g., `mv old.txt new.txt`).
* **Q9: How to search for a string in a file?**  
  Using `grep` (e.g., `grep "pattern" file.txt`).
* **Q10: Difference between `grep` and `egrep`?**  
  `egrep` (Extended grep / `grep -E`) supports extended regular expressions including multiple patterns with pipe `|` (e.g., `egrep "error|warn|fail" app.log`).
* **Q11: How to read a file without using `cat`?**  
  Using `less`, `more`, `head`, `tail`, or opening with `vi`/`vim`/`nano`.
* **Q12: Advantage of `less` command?**  
  Handles large files without loading everything into RAM, allows forward/backward scrolling with arrow keys, search functionality (`/search_term`), and fast navigation.
* **Q13: How to check file permissions?**  
  `ls -l`, `ll`, or `getfacl <filename>`.
* **Q14: How to check IP address of Linux server?**  
  `ip addr` (or `ip a`), `ifconfig`, or `hostname -I`.
* **Q15: How to read top 5 lines of a file?**  
  `head -n 5 file_name` (or `head -5 file_name`).
* **Q16: How to read last 5 lines of a file?**  
  `tail -n 5 file_name` (or `tail -5 file_name`).
* **Q17: How to list hidden files?**  
  `ls -la` or `ls -a`.
* **Q18: How to see recently executed commands?**  
  `history` (can run `!n` to rerun nth command).
* **Q19: What is root?**  
  The superuser/administrator account with full system privileges; `/root` is the root user's home folder, while `/` is the root of the filesystem.
* **Q20: What is an inode and how to find it?**  
  An inode (index node) is a data structure storing file metadata (file type, size, permissions, owner, block pointers) excluding filename. View with `ls -li` or filesystem inodes with `df -i`.
* **Q21: Which commands find files on Linux?**  
  `find /path -name "file*"` and `locate <filename>`.
* **Q22: Command for counting words and lines?**  
  `wc` (words, lines, chars), `wc -l` (lines only).
* **Q23: What is pipe (`|`) used for?**  
  Combines two or more commands by taking the standard output (`stdout`) of the first command and passing it as standard input (`stdin`) to the second (e.g., `ps aux | grep nginx`).
* **Q24: How to view differences between two files?**  
  `diff file1 file2` (or `vimdiff file1 file2`).
* **Q25: What is the use of `shred` command?**  
  Securely deletes files by overwriting data blocks with random bytes so it cannot be recovered (`shred -u file.txt` or `shred --remove file.txt`).
* **Q26: How to check system hardware/architecture info?**  
  `lscpu`, `uname -m`, and `sudo dmidecode`.
* **Q27: How to combine two files into one?**  
  `cat file1 file2 > file3`
* **Q28: How to find the type of a file?**  
  `file <filename>`
* **Q29: How to sort content of a file?**  
  `sort filename` (or `cat filename | sort`).

### Remote Access & Permissions
* **Q30: Ways to access a remote Linux server from Windows?**  
  Using SSH clients: PowerShell/CMD (`ssh -i key.pem user@ip`), Git Bash, Windows Terminal, PuTTY.
* **Q31: What are the 3 main permission types in Linux?**  
  Read (`r` = 4), Write (`w` = 2), Execute (`x` = 1).
* **Q32: Which permission allows running a script?**  
  Execute (`x`) permission (applied via `chmod +x script.sh` or `chmod 755 script.sh`).
* **Q33: How to write command output to a file?**  
  Using `>` operator: `cat test.txt > output.txt`.
* **Q34: How to write to a file without deleting existing content?**  
  Using append `>>` operator: `echo "New entry $(date)" >> app.log`.
* **Q35: How to redirect error output to a file?**  
  Using `2>` (e.g., `command 2> error.log`) or both output and errors with `2>&1` or `&>`.

### Task Automation & Cron Jobs
* **Q36: How to automate tasks or scripts?**  
  Using **Cron Jobs** (`crontab -e`) for recurring schedules, or `at` for one-off scheduled runs.
* **Q37: How to check scheduled cron jobs?**  
  `crontab -l` (for current user) or `sudo crontab -u username -l`.
* **Q38: What is the meaning of cron job `* * * * *`?**  
  Runs the scheduled command every minute of every hour of every day indefinitely:
  * Field 1: Minute (`0-59`)
  * Field 2: Hour (`0-23`)
  * Field 3: Day of Month (`1-31`)
  * Field 4: Month (`1-12`)
  * Field 5: Day of Week (`0-6`, 0=Sunday)
* **Q39: If a cron job fails to run, how to troubleshoot?**  
  1. Check system date/timezone: `date`
  2. Verify cron daemon status: `systemctl status cron` (or `crond`)
  3. Inspect cron execution logs: `/var/log/syslog` or `/var/log/cron` (RHEL)
  4. Ensure absolute paths are used for all commands and binaries inside the script.

### Services & Resource Diagnostics
* **Q40: What is a daemon service?**  
  A background process that runs continuously without direct user interaction (e.g. `sshd`, `nginx`, `systemd`, `crond`).
* **Q41: How to check if a service is running?**  
  `systemctl status <service_name>`
* **Q42: How to start/stop any service?**  
  `sudo systemctl start <service>` / `sudo systemctl stop <service>`
* **Q43: How to check free disk space?**  
  `df -h`
* **Q44: How to check directory size?**  
  `du -sh /path/to/dir`
* **Q45: How to check CPU usage for processes?**  
  `top`, `htop`, or `ps aux --sort=-%cpu | head -n 10`
* **Q46: What is a process in Linux?**  
  An executing instance of a program assigned a unique Process ID (PID).
* **Q47: How to check if an application/process is running?**  
  `ps aux | grep <process_name>` or `pgrep -l <process_name>`
* **Q48: How to terminate a running process?**  
  `kill <PID>` or force kill with `kill -9 <PID>` (`SIGKILL`).

### Networking & Security
* **Q49: How to check if remote IP/Server is reachable?**  
  `ping <IP_OR_DOMAIN>` or `nc -zv <IP> <PORT>` or `telnet <IP> <PORT>`
* **Q50: Which command provides open port information?**  
  `netstat`, `ss`, or `lsof`.
* **Q51: How to check open listening ports?**  
  `netstat -tuln | grep :80` or `sudo ss -tuln | grep :80`
* **Q52: What are common use cases for `lsof` (List Open Files)?**  
  * Find process using a specific port: `sudo lsof -i :80`
  * Find files opened by a specific PID: `lsof -p <PID>`
  * Find which process holds a file open: `lsof /var/log/app.log`
* **Q53: How to check network interfaces in Linux?**  
  `ip addr` (or `ifconfig`).
* **Q54: Difference between Telnet and SSH?**  
  * **SSH (Port 22):** Encrypted, secure protocol for remote CLI management.
  * **Telnet (Port 23):** Plaintext, unencrypted, insecure protocol.
* **Q55: Which service must be active to allow remote SSH login?**  
  `sshd` (SSH daemon).
* **Q56: What is SSH?**  
  Secure Shell — a cryptographic network protocol for operating network services securely over an unsecured network.
* **Q57: Why is SSH called Secure Shell?**  
  All traffic (authentication credentials, commands, data) is end-to-end encrypted using asymmetric and symmetric key cryptography.
* **Q58: Which command accesses a Linux server from terminal?**  
  `ssh user@<hostname-or-ip>` (or `ssh -i key.pem user@<ip>`).

---

## 6. Hands-on Practice Scripts

* [`scripts/io_and_env_demo.sh`](./scripts/io_and_env_demo.sh) — Script demonstrating standard output, error redirection, environment variables, and shell special arguments (`$0`, `$1`, `$#`, `$?`).
* [`scripts/rsync_backup_demo.sh`](./scripts/rsync_backup_demo.sh) — Automated incremental directory backup script using `rsync` with `--dry-run` and archive flags.
