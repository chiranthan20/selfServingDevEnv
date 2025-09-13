# Use Ubuntu base
FROM ubuntu:22.04

# Prevent interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# Update & install common dev tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    build-essential \
    python3 \
    python3-pip \
    nodejs \
    npm \
    iputils-ping \
    net-tools \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI (optional, not Docker engine)
RUN curl -fsSL https://get.docker.com/rootless | sh

# Create a non-root user for development
RUN useradd -ms /bin/bash devuser \
    && echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER devuser
WORKDIR /home/devuser

# Default shell
CMD ["/bin/bash"]