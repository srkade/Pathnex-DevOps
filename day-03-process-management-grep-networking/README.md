# Day 3: Process Management, Grep, System Info & Networking Commands

**Date:** Oct 04  
**Topic:** Process Management (`ps`, `top`, `kill`, `pkill`, `pgrep`), `grep` pattern searching, System hardware diagnostics (`du`, `lspci`, `lsusb`), and Networking commands (`ping`, `netstat`, `ss`, `ssh`, `scp`, `curl`, `wget`).

---

## 1. Process Management Commands

A process is an instance of a running program in Linux. Every process has a unique identifier called **Process ID (PID)**.

| Command | Description | Useful Options / Flags | Example & Explanation |
| :--- | :--- | :--- | :--- |
| `ps` | Display snapshot of currently running processes. | `aux` (a = all users, u = user/owner format, x = processes without tty) | `ps aux`<br>Shows all running processes with PID, CPU %, Memory %, and command name. |
| `top` | Monitor system processes dynamically in real-time. | `top`<br>(Press `q` to quit, `k` to kill a PID, `M` to sort by memory, `P` to sort by CPU) | `top`<br>Displays live CPU/RAM utilization and top resource-consuming processes. |
| `kill` | Terminate a running process using its PID. | `-9` : Forcefully kill process immediately (SIGKILL). | `kill 1234`<br>`kill -9 1234`<br>Sends termination signal to process with PID 1234. |
| `pkill` | Terminate processes directly by their program/process name. | `-9` : Force kill by name. | `pkill nginx`<br>`pkill -9 python3`<br>Kills all processes matching the specified process name. |
| `pgrep` | Look up or list process IDs based on process name. | `-l` : List PID along with process name. | `pgrep nginx`<br>`pgrep -l node`<br>Outputs all process IDs matching the given name. |

### Practical Process Management Workflow:
```bash
# 1. Search for a specific running process (e.g., node or nginx)
pgrep -l nginx
# or using ps and grep:
ps aux | grep nginx

# 2. Terminate gracefully first
kill <PID>

# 3. If process is hanging / unresponsive, force kill
kill -9 <PID>

# 4. Or kill all instances by process name
pkill nginx
```

---

## 2. Text Search with `grep`

`grep` (Global Regular Expression Print) is used to search for text patterns inside files or output streams.

### Common Options:
* `-i` : Ignore case distinctions (case-insensitive search).
* `-v` : Invert match (show lines that do NOT match the pattern).
* `-r` or `-R` : Search recursively through directories and subdirectories.
* `-l` : Print only names of matching files (not the matching lines).
* `-n` : Display line numbers with output.
* `-w` : Match whole words only.
* `-c` : Count total number of matching lines.
* `-e` : Specify multiple search patterns.
* `-A <N>` : Print N lines **After** the match.
* `-B <N>` : Print N lines **Before** the match.
* `-C <N>` : Print N lines of **Context** (both before & after).

### Hands-on Examples:
```bash
# Case-insensitive search for "hello" in file.txt
grep -i "hello" file.txt

# Invert match: Display all lines EXCEPT those containing "error"
grep -v "error" /var/log/app.log

# Recursively search for "DB_PASSWORD" across all project files
grep -r "DB_PASSWORD" ./src/

# Find which files contain the keyword "PORT" (prints file names only)
grep -l "PORT" /etc/nginx/sites-available/*

# Show matching line along with line number
grep -n "root" /etc/passwd

# Match whole word only (matches "port" but not "portable" or "support")
grep -w "port" server.conf

# Count how many times 404 errors appear in access log
grep -c " 404 " access.log

# Show 3 lines before and after an error in log file
grep -C 3 "NullPointerException" catalina.out
```

---

## 3. System Information & Hardware Commands

Commands to inspect server resources, disk sizes, and connected hardware.

| Command | Description | Useful Options | Example |
| :--- | :--- | :--- | :--- |
| `uname` | Print operating system and kernel info. | `-a` : Display all system information. | `uname -a` |
| `whoami` | Display current logged-in username. | — | `whoami` |
| `df` | Show filesystem disk space usage. | `-h` : Human-readable format (MB/GB). | `df -h` |
| `du` | Estimate file and directory space usage. | `-s` : Summary (total size only)<br>`-h` : Human-readable | `du -sh /var/log/`<br>`du -h --max-depth=1 /home` |
| `free` | Display total, used, and free RAM & swap memory. | `-h` : Human-readable format. | `free -h` |
| `uptime` | Show how long system has been running and load averages. | `-p` : Pretty print format. | `uptime` |
| `lscpu` | Display detailed CPU architecture, cores, and model. | — | `lscpu` |
| `lspci` | List all PCI devices (graphics, network adapters, controllers). | — | `lspci` |
| `lsusb` | List connected USB devices. | — | `lsusb` |

---

## 4. Networking Commands

Networking tools for diagnosing connectivity, inspecting open ports, remote server access, and file transfer.

| Command | Description | Example & Usage |
| :--- | :--- | :--- |
| `ifconfig` / `ip a` | Display network interfaces and IP configurations. | `ifconfig`<br>`ip addr show` |
| `ping` | Send ICMP echo requests to test network reachability. | `ping -c 4 google.com`<br>Sends 4 packets to test connectivity and packet loss. |
| `netstat` | Display active network connections, routing tables, and listening ports. | `netstat -tuln`<br>`-t` (TCP), `-u` (UDP), `-l` (listening), `-n` (numeric ports). |
| `ss` | Modern replacement for `netstat` (faster socket statistics). | `ss -tuln`<br>`ss -tulpn` (shows process names as well with sudo). |
| `ssh` | Connect securely to a remote server over SSH (Port 22). | `ssh -i key.pem ubuntu@54.210.10.20` |
| `scp` | Securely copy files between local and remote machines over SSH. | `scp -i key.pem index.html ubuntu@54.210.10.20:/var/www/html/`<br>`scp -i key.pem user@remote:/path/file.txt ./` |
| `wget` | Non-interactive command-line file downloader. | `wget https://wordpress.org/latest.tar.gz` |
| `curl` | Transfer data to/from servers supporting HTTP, HTTPS, FTP, etc. | `curl -I http://example.com` (fetch headers)<br>`curl -s http://ipinfo.io/ip` (get public IP) |

### Practical Networking Checklist:
```bash
# Check if port 80 (HTTP) or port 22 (SSH) is actively listening
sudo ss -tulpn | grep -E ':80|:22'

# Test if an external API or website is accessible
curl -I https://google.com

# Copy a configuration file to EC2 server
scp -i ~/.ssh/devops-key.pem ./nginx.conf ubuntu@<EC2-IP>:/tmp/
```

---

## 5. Day 3 Script
Authored [`scripts/health_check_and_monitor.sh`](./scripts/health_check_and_monitor.sh) demonstrating process checking, disk alert calculation with `df`/`du`, and network port verification.
