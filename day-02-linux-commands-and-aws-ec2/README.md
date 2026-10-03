# Day 2: Linux File & Directory Commands, Permissions & AWS EC2 Setup

**Date:** Oct 03  
**Topic:** File and Directory Operations, File Permissions (`chmod`, `chown`) with examples, and Launching a Linux Server on AWS EC2

---

## Part 1: File and Directory Operations

### 1. Navigation & Path Commands
* `pwd` : Print Working Directory (shows current location in filesystem).
* `cd <path>` : Change Directory.
  * `cd ..` : Go back one folder up.
  * `cd ~` or just `cd` : Go to current user's home directory.
  * `cd -` : Go back to previous directory.

### 2. Listing Files (`ls`)
```bash
ls          # simple list
ls -l       # long listing format (shows permissions, owner, size, date)
ls -a       # show all files including hidden files (.bashrc, .env, etc.)
ls -la      # long listing with hidden files
ls -lh      # human readable file size (KB, MB, GB)
ls -lt      # sort by modified time (latest first)
```

### 3. Creating Files & Directories
```bash
# Create a single directory
mkdir devops-class

# Create nested directories in one command (-p = parent)
mkdir -p project/src/components

# Create empty file
touch server.js
touch app.env notes.txt
```

### 4. Copying & Moving Files (`cp`, `mv`)
```bash
# Copy file to another name
cp config.txt config.txt.bak

# Copy an entire folder recursively (-r)
cp -r project/ backup_project/

# Rename a file
mv old_name.txt new_name.txt

# Move file into a folder
mv app.log /var/log/
```

### 5. Deleting Files & Folders (`rm`, `rmdir`)
```bash
# Remove an empty directory
rmdir old_folder/

# Remove a single file
rm temp.txt

# Remove a folder with all its contents (-r = recursive, -f = force)
rm -rf temp_folder/
```
> **Note:** Be very careful while running `rm -rf` because in Linux deleted files cannot be restored from recycle bin.

### 6. Reading File Content
```bash
# View entire file
cat /etc/os-release

# View file with line numbers
cat -n script.sh

# View large files page by page (press 'q' to exit)
less /var/log/syslog

# View top 10 lines
head -n 10 /etc/passwd

# View last 10 lines (very useful for logs)
tail -n 10 app.log

# Live streaming/following logs as they come in
tail -f app.log
```

---

## Part 2: Linux File Permissions & Ownership

In Linux every file and directory has 3 types of owners:
1. **User (u):** The user who owns the file.
2. **Group (g):** Group of users who share access.
3. **Others (o):** Anyone else on the system.

### Understanding the Permission String:
When running `ls -l`:
`-rwxr-xr-- 1 ubuntu ubuntu 4096 Oct 3 10:00 app.sh`

* The first character `-` means regular file (`d` means directory).
* Next 3 characters `rwx` -> **User/Owner** has Read, Write, Execute.
* Next 3 characters `r-x` -> **Group** has Read and Execute (no write).
* Next 3 characters `r--` -> **Others** have Read only.

### Permission Values (Octal/Numeric):
* **Read (`r`)** = `4`
* **Write (`w`)** = `2`
* **Execute (`x`)** = `1`
* **No Permission (`-`)** = `0`

Common Combinations:
* `7` = `4 + 2 + 1` (`rwx`) -> Full permissions
* `6` = `4 + 2 + 0` (`rw-`) -> Read & write
* `5` = `4 + 0 + 1` (`r-x`) -> Read & execute
* `4` = `4 + 0 + 0` (`r--`) -> Read only

### Examples using `chmod` (Change Mode):

#### 1. Numeric / Octal Method:
```bash
# Make script executable by owner, readable by others (755)
chmod 755 deploy.sh

# Private file only readable & writable by owner (600)
chmod 600 config.env

# AWS Key Pair permission (Read only for owner)
chmod 400 my-key.pem

# Public file (Read-write for owner, read-only for others)
chmod 644 index.html
```

#### 2. Symbolic Method:
```bash
# Add execute permission for current user
chmod u+x run.sh

# Remove write permission for group and others
chmod go-w notes.txt

# Add read permission for everyone
chmod a+r readme.md
```

### Changing Ownership (`chown` and `chgrp`):
```bash
# Change owner of file to 'ubuntu'
sudo chown ubuntu app.js

# Change owner and group together (user:group)
sudo chown ubuntu:devops project/ -R

# Change group only
sudo chgrp devops /var/www/
```

---

## Part 3: How to Create a Linux Server on AWS EC2 (Step-by-Step)

In class today we launched our first cloud virtual machine using AWS EC2 (Elastic Compute Cloud).

### Step 1: Open AWS Console
1. Log in to [AWS Management Console](https://aws.amazon.com/console/).
2. Select your nearest region (e.g. `ap-south-1` Mumbai or `us-east-1` N. Virginia).
3. Search for **EC2** and click on it.

### Step 2: Launch Instance
1. Click on **Launch Instance** (orange button).
2. **Name:** `my-first-devops-server`
3. **OS Image (AMI):** Select **Ubuntu** (Ubuntu Server 22.04 LTS or 24.04 LTS - Free tier eligible).
4. **Instance Type:** Select `t2.micro` (1 vCPU, 1 GB RAM - Free Tier).

### Step 3: Key Pair (Login Credentials)
1. Click **Create new key pair**.
2. **Name:** `devops-key`
3. **Key pair type:** `RSA`
4. **Private key file format:** `.pem` (for OpenSSH / Mac / Linux / Windows Terminal).
5. Click **Create key pair** (this will download `devops-key.pem` to your computer. Keep it safe!).

### Step 4: Network Settings (Security Group / Firewall)
1. Allow **SSH traffic from Anywhere (0.0.0.0/0)** or **My IP** (Port 22).
2. Check the box to **Allow HTTP traffic from the internet** (Port 80) for web server testing.

### Step 5: Launch & Connect
1. Keep default storage (8 GB gp3 SSD) and click **Launch instance**.
2. Wait until status shows **Running** and **2/2 checks passed**.
3. Note down the **Public IPv4 address** of your instance.

---

## Part 4: Connecting via SSH from Local Terminal

Open your local terminal (Git Bash, PowerShell, or macOS terminal):

```bash
# 1. Navigate to the folder where your key is downloaded (usually Downloads)
cd ~/Downloads

# 2. Fix permission on key file (VERY IMPORTANT, otherwise SSH throws UNPROTECTED PRIVATE KEY FILE error)
chmod 400 devops-key.pem

# 3. Connect to instance using SSH
ssh -i "devops-key.pem" ubuntu@<YOUR-EC2-PUBLIC-IP>
```

### Initial Server Check on EC2:
Once logged in, verify and update the instance:
```bash
# Update package list
sudo apt update

# Install Nginx web server to test
sudo apt install nginx -y

# Check if Nginx is running
sudo systemctl status nginx
```
Open `http://<YOUR-EC2-PUBLIC-IP>` in browser to see the default Nginx page!

---

## Practice Scripts Created:
* [`scripts/file_manager_demo.sh`](./scripts/file_manager_demo.sh) - Hands-on practice creating directories and changing permissions.
* [`scripts/ec2_bootstrap.sh`](./scripts/ec2_bootstrap.sh) - Sample startup script (User Data) to auto-install Nginx on boot.
