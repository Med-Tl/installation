# Ubuntu Installation Script

This project contains an interactive Bash script to automate the installation and configuration of common services on Ubuntu machines.

The script allows you to choose what you want to install:

- Docker (installed from the official Docker repository)
- Docker Compose Plugin
- Docker Buildx
- Nginx

The script also:

- Updates and upgrades the system before and after installation
- Starts and enables installed services
- Adds the current user to the Docker group to use Docker without `sudo`
- Configures Docker permissions automatically

---

# Installation & Usage

## 1. Clone the repository

Clone the repository on your Ubuntu machine:

```bash
git clone <repository-url>
```

Move into the project directory:

```bash
cd installation
```

---

## 2. Give execution permission to the script

Make the installation script executable:

```bash
chmod +x install.sh
```

---

## 3. Run the installation script

Execute the script with administrator privileges:

```bash
sudo ./install.sh
```

---

# Installation Process

During execution, the script will ask you what you want to install.

Example:

```text
Do you want to install Docker? (y/n):

Do you want to install Nginx? (y/n):
```

Choose:

```text
y → Install the service

n → Skip the installation
```

The script will automatically:

- Update the system packages
- Install selected services
- Install Docker from the official Docker repository
- Install Docker Compose Plugin and Buildx
- Enable services at startup
- Start services
- Configure Docker permissions
- Add the current user to the Docker group

---

# Docker Installation

The script installs Docker using the official Docker repository.

Installed components:

- Docker Engine
- Docker CLI
- Containerd
- Docker Buildx
- Docker Compose Plugin

This method provides the latest stable Docker version and avoids compatibility problems with Ubuntu default packages.

---

# Verify Docker Installation

After the installation is completed, check the Docker service status:

```bash
sudo systemctl status docker
```

Expected result:

```text
Active: active (running)
```

If Docker is running, the installation is successful.

---

# If Docker Is Not Running

Start Docker manually:

```bash
sudo systemctl start docker
```

Enable Docker to start automatically after reboot:

```bash
sudo systemctl enable docker
```

Check the status again:

```bash
sudo systemctl status docker
```

---

# Use Docker Without sudo

The script automatically adds your user account to the Docker group.

Example:

```text
User 'username' has been added to the docker group.
```

However, the current terminal session may not have the new permissions yet.

You have two options:

---

## Option 1: Reconnect your terminal

Close your terminal or SSH session and reconnect.

Then test Docker:

```bash
docker ps
```

---

## Option 2: Refresh the group immediately

Run:

```bash
newgrp docker
```

Then test Docker:

```bash
docker ps
```

You should now be able to use Docker without `sudo`.

Example:

Before:

```bash
sudo docker ps
```

After:

```bash
docker ps
```

---

# Troubleshooting

## Docker permission denied

If you see:

```text
permission denied while trying to connect to the Docker API
```

Run:

```bash
newgrp docker
```

or reconnect your terminal.

---

## Docker daemon is not running

Check Docker status:

```bash
sudo systemctl status docker
```

Start Docker:

```bash
sudo systemctl start docker
```

Enable Docker:

```bash
sudo systemctl enable docker
```

Restart Docker:

```bash
sudo systemctl restart docker
```

---

# Verify Installed Versions

## Docker

```bash
docker --version
```

Example:

```text
Docker version 29.x.x
```

---

## Docker Compose

```bash
docker compose version
```

Example:

```text
Docker Compose version v2.x.x
```

---

## Nginx

```bash
nginx -v
```

Example:

```text
nginx version: nginx/1.x.x
```

---

# Supported Systems

This script is designed for:

- Ubuntu 20.04 LTS
- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS

---

# Project Structure

The repository should look like this:

```
installation/
│
├── install.sh
└── README.md
```

---

# Requirements

Before running the script:

- Ubuntu machine
- Internet connection
- User with sudo privileges

---

# Complete Installation Workflow

Run the following commands:

```bash
git clone <repository-url>

cd installation

chmod +x install.sh

sudo ./install.sh
```

Choose the required installations.

After completion:

```bash
sudo systemctl status docker
```

If Docker is running:

```bash
newgrp docker

docker ps
```

---

# Author

Created to simplify Ubuntu server preparation and automate common DevOps environment setup tasks.

---

# License

This project is free to use and modify.
