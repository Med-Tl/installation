#!/bin/bash

####################################################
# Ubuntu Interactive Installer
# Installs Docker (Official Repo) and Nginx
####################################################

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script using sudo."
    exit 1
fi

CURRENT_USER=${SUDO_USER:-$(whoami)}

echo "=========================================="
echo " Ubuntu Interactive Installer"
echo "=========================================="

############################################
# Yes/No Prompt
############################################
ask_install() {
    while true; do
        read -rp "$1 (y/n): " answer
        case "$answer" in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo "Please answer y or n." ;;
        esac
    done
}

############################################
# System Update
############################################
echo
echo "Updating system..."

if apt update && apt upgrade -y; then
    echo "System updated successfully."
else
    echo "System update encountered errors."
    echo "Continuing..."
fi

############################################
# Docker (Official Repository)
############################################
if ask_install "Do you want to install Docker?"; then

    echo
    echo "Installing Docker from the official repository..."

    # Remove old versions
    apt remove -y docker docker-engine docker.io containerd runc >/dev/null 2>&1 || true

    # Install prerequisites
    if ! apt install -y ca-certificates curl gnupg lsb-release; then
        echo "Failed to install prerequisites."
    else

        # Create keyring directory
        install -m 0755 -d /etc/apt/keyrings

        # Remove existing key (if any)
        rm -f /etc/apt/keyrings/docker.gpg

        # Download Docker GPG key
        if curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
            | gpg --dearmor -o /etc/apt/keyrings/docker.gpg; then

            chmod a+r /etc/apt/keyrings/docker.gpg

            # Add Docker repository
            echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
> /etc/apt/sources.list.d/docker.list

            apt update

            # Install Docker
            if apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; then

                systemctl enable docker
                systemctl start docker

                groupadd -f docker
                usermod -aG docker "$CURRENT_USER"

                echo
                echo "===================================="
                echo "Docker installed successfully!"
                echo "===================================="

                docker --version
                docker compose version

            else
                echo "Docker installation failed."
            fi

        else
            echo "Failed to download Docker GPG key."
        fi
    fi
fi

############################################
# Nginx
############################################
if ask_install "Do you want to install Nginx?"; then

    echo
    echo "Installing Nginx..."

    if apt install -y nginx; then

        systemctl enable nginx
        systemctl start nginx

        echo "Nginx installed successfully."

    else
        echo "Failed to install Nginx."
    fi
fi

############################################
# Final Update
############################################
echo
echo "Running final update..."

if apt update && apt upgrade -y; then
    echo "Final update completed."
else
    echo "Final update completed with some errors."
fi

############################################
# Summary
############################################
echo
echo "=========================================="
echo " Installation Completed"
echo "=========================================="

echo

if command -v docker >/dev/null 2>&1; then
    echo "Docker Version:"
    docker --version
fi

if docker compose version >/dev/null 2>&1; then
    echo "Docker Compose Version:"
    docker compose version
fi

if command -v nginx >/dev/null 2>&1; then
    echo "Nginx Version:"
    nginx -v 2>&1
fi

echo

if groups "$CURRENT_USER" | grep -q docker; then
    echo "User '$CURRENT_USER' is already in the docker group."
else
    echo "User '$CURRENT_USER' has been added to the docker group."
    echo "Please log out and log back in (or run 'newgrp docker')"
    echo "to use Docker without sudo."
fi

echo
echo "All requested tasks have been processed."
