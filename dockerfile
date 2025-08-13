# Use the official Ubuntu 24.04 image as the base.
FROM ubuntu:24.04

# Prevent interactive prompts during package installation.
ENV DEBIAN_FRONTEND=noninteractive

# Install a desktop environment (XFCE4), the VNC server, git, and other tools.
RUN apt-get update && \
    apt-get install -y xfce4 xfce4-goodies tightvncserver xterm sudo wget curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add a default non-root user. The `start.sh` script will use this user or a custom one.
RUN useradd -m -s /bin/bash vncuser && \
    echo "vncuser:vncuser" | chpasswd && \
    echo "vncuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set the default user and working directory.
USER vncuser
WORKDIR /home/vncuser

# Expose the standard VNC port (5901).
EXPOSE 5901

# Copy all the necessary scripts into the image.
COPY start.sh /start.sh
COPY vnc-startup.sh /home/vncuser/.vnc/xstartup
COPY heartbeat.sh /home/vncuser/heartbeat.sh

# Make the scripts executable.
RUN chmod +x /start.sh /home/vncuser/.vnc/xstartup /home/vncuser/heartbeat.sh

# The main command to run when the container starts.
# It will execute the start.sh script to handle configuration and startup.
CMD ["/start.sh"]
