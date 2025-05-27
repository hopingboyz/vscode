# Use the official code-server base with Ubuntu
FROM codercom/code-server:latest

# Switch to root for system configuration
USER root

# Install essential system tools and dependencies
RUN apt-get update && \
    apt-get install -y \
    sudo \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    build-essential \
    gnupg2 \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    lsb-release \
    openssh-server \
    net-tools \
    iputils-ping \
    dnsutils \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Docker CLI (Docker-in-Docker setup)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a root user with password (change 'rootpass' to your desired password)
RUN echo 'root:rootpass' | chpasswd && \
    usermod -aG sudo coder && \
    echo 'coder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install essential VS Code extensions
RUN code-server --install-extension ms-python.python && \
    code-server --install-extension eamodio.gitlens && \
    code-server --install-extension ms-azuretools.vscode-docker && \
    code-server --install-extension vscodevim.vim && \
    code-server --install-extension esbenp.prettier-vscode && \
    code-server --install-extension ms-vscode-remote.remote-containers

# Configure workspace and permissions
WORKDIR /workspace
RUN chown -R coder:coder /workspace && \
    chmod -R 755 /workspace

# Switch back to coder user for security (use 'su root' when needed)
USER coder

# Set environment variables
ENV SHELL=/bin/bash
ENV PASSWORD=yoursecurepassword  # Change this or override with -e when running

# Expose ports: code-server + SSH (optional)
EXPOSE 8080 2222

# Start script to handle both code-server and SSH
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sudo chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
