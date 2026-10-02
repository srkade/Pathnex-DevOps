# Day 1: DevOps Roadmap & Linux Basics

**Date:** Oct 02  
**Topic:** What is DevOps, DevOps Roadmap, Linux Architecture & Basic Commands

---

## 1. What is DevOps?

In simple words, DevOps is not just a tool or a role; it is a culture and set of practices that bridges the gap between **Software Developers (Dev)** and **IT Operations (Ops)**.

### Traditional Problem:
* Developers build code on their machine ("It works on my machine!").
* Operations team deploys to production servers and faces dependency or environment issues.
* Releases used to take weeks or months.

### DevOps Solution:
* Automated testing, continuous integration, and frequent delivery.
* Shared responsibility for monitoring and uptime.

---

## 2. DevOps Roadmap (What we will learn)

1. **Linux Fundamentals & Shell Scripting** (Commands, Permissions, Bash scripting)
2. **Version Control (Git & GitHub)** (Branching, Pull Requests, Merge conflicts)
3. **Cloud Computing (AWS)** (EC2, VPC, S3, IAM, Security Groups)
4. **Networking Basics** (DNS, IP addresses, Ports, SSH, HTTP/HTTPS)
5. **Continuous Integration & Delivery (CI/CD)** (Jenkins / GitHub Actions)
6. **Containers & Orchestration** (Docker & Kubernetes)
7. **Infrastructure as Code (IaC)** (Terraform)
8. **Monitoring & Logging** (Prometheus, Grafana)

---

## 3. Why Linux for DevOps?

* Most cloud servers, virtual machines, and Docker containers run on Linux.
* Open source, secure, reliable, and lightweight.
* Powerful command line interface (CLI) for automation and scripting.

### Basic Architecture:
* **Hardware:** Physical CPU, RAM, Hard Disk.
* **Kernel:** Core of OS, directly interacts with hardware.
* **Shell (Bash):** Interface/CLI where we type commands.
* **Applications:** Utilities like `cat`, `ls`, `grep`, `systemctl`.

### Key Directories in Linux:
* `/` - Root directory (top level)
* `/home/<username>` - User home folder
* `/root` - Superuser (root) home folder
* `/etc` - All system and service configuration files (e.g. `/etc/passwd`, `/etc/ssh`)
* `/var/log` - System and application logs
* `/tmp` - Temporary files (gets cleaned up on reboot)
* `/bin` and `/usr/bin` - Common command executable files

---

## 4. Commands Practiced in Class

### System Information Commands
```bash
# Check logged-in user
whoami

# Print system info / kernel version
uname -r
uname -a

# Print hostname
hostname

# Check OS distribution details
cat /etc/os-release
```

### Checking Resources & Uptime
```bash
# Check system uptime and load average
uptime

# Check RAM and swap memory usage (in human readable format MB/GB)
free -m
free -h

# Check hard disk partition usage
df -h

# Check CPU details
lscpu

# Live process monitor (press 'q' to exit)
top
```

---

## 5. Hands-on Task
Created a simple bash script `sys_info.sh` in the `scripts/` folder to print out basic system details automatically.

To run it:
```bash
chmod +x ./scripts/sys_info.sh
./scripts/sys_info.sh
```
