#!/bin/bash

# This script initializes the VNC environment and starts the VNC server.

# Set default user and password if not provided.
VNC_USER=${VNC_USER:-vncuser}
VNC_PASSWORD=${VNC_PASSWORD:-vncuser}

# Check for a custom user. If VNC_USER is set, create a new user.
if [ "$VNC_USER" != "vncuser" ] && [ "$VNC_USER" != "root" ]; then
    useradd -m -s /bin/bash "$VNC_USER" && \
    echo "$VNC_USER:$VNC_PASSWORD" | chpasswd && \
    echo "$VNC_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    # Switch to the new user and clone the repo
    su -c "git clone https://github.com/lowclassff/CURLNODE-HB.git" - "$VNC_USER"
    # Set the VNC password for the new user
    su -c "mkdir -p ~/.vnc && echo -e \"$VNC_PASSWORD\n$VNC_PASSWORD\n\" | vncpasswd && chmod 600 ~/.vnc/passwd" - "$VNC_USER"
    # Run the VNC server and heartbeat script as the new user
    su -c "/usr/bin/vncserver :1 -geometry 1280x720 & /home/$VNC_USER/heartbeat.sh" - "$VNC_USER"
else
    # If using the default user (vncuser) or root, proceed with that user.
    if [ "$VNC_USER" == "root" ]; then
        echo "WARNING: Running VNC as the root user is not recommended for security reasons."
        # Clone the repo for the root user.
        git clone https://github.com/lowclassff/CURLNODE-HB.git
        # Set the VNC password for the root user.
        mkdir -p /root/.vnc && echo -e "$VNC_PASSWORD\n$VNC_PASSWORD\n" | vncpasswd && chmod 600 /root/.vnc/passwd
        # Start VNC and heartbeat script for the root user.
        /usr/bin/vncserver :1 -geometry 1280x720 & /root/heartbeat.sh
    else
        # Clone the repo for the default user.
        su -c "git clone https://github.com/lowclassff/CURLNODE-HB.git" - vncuser
        # Set the VNC password for the default user.
        su -c "mkdir -p ~/.vnc && echo -e \"$VNC_PASSWORD\n$VNC_PASSWORD\n\" | vncpasswd && chmod 600 ~/.vnc/passwd" - vncuser
        # Start VNC and heartbeat script for the default user.
        su -c "/usr/bin/vncserver :1 -geometry 1280x720 & /home/vncuser/heartbeat.sh" - vncuser
    fi
fi
