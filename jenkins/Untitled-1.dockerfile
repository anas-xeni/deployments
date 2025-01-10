FROM jenkins/inbound-agent:3273.v4cfe589b_fd83-1

USER root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg \
    lsb-release

# Setup Docker repository
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CLI and Buildx
RUN apt-get update && \
    apt-get install -y docker-ce-cli docker-buildx-plugin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Setup Docker Buildx for jenkins user
RUN mkdir -p /home/jenkins/.docker/cli-plugins && \
    ln -sf /usr/libexec/docker/cli-plugins/docker-buildx /home/jenkins/.docker/cli-plugins/docker-buildx && \
    chown -R jenkins:jenkins /home/jenkins/.docker 
# Install Go
RUN wget https://go.dev/dl/go1.23.4.linux-arm64.tar.gz && \
    tar -C /usr/local -xzf go1.23.4.linux-arm64.tar.gz && \
    rm go1.23.4.linux-arm64.tar.gz

# RUN groupadd docker
# RUN usermod -aG docker jenkins

# USER jenkins
# Add Go to PATH
ENV PATH=$PATH:/usr/local/go/bin

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]













FROM jenkins/inbound-agent:3273.v4cfe589b_fd83-1

USER root

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg \
    lsb-release \
    sudo

RUN apt-get install -y jq
# Setup Docker repository
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN wget https://go.dev/dl/go1.23.4.linux-arm64.tar.gz && \
    tar -C /usr/local -xzf go1.23.4.linux-arm64.tar.gz && \
    rm go1.23.4.linux-arm64.tar.gz

RUN VERSION=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | jq -r .tag_name) && \
    curl -Lo trivy.tar.gz https://github.com/aquasecurity/trivy/releases/download/${VERSION}/trivy_${VERSION}_Linux-arm64.tar.gz && \
    tar -zxvf trivy.tar.gz && \
    mv trivy /usr/local/bin/ && \
    rm trivy.tar.gz


RUN usermod -aG root jenkins
RUN chmod 777 /usr/bin/docker 


ENV PATH=$PATH:/usr/local/go/bin

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chown jenkins:jenkins /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# USER jenkins
ENTRYPOINT ["/docker-entrypoint.sh"]











#!/usr/bin/env bash

dockerd &

for i in {1..10}; do
    docker version > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Docker daemon is up and running."
        break
    fi
    echo "Waiting for Docker daemon to start..."
    sleep 2
done

exec /usr/local/bin/jenkins-agent "$@"