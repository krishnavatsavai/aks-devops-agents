# Use the official Ubuntu base image
FROM ubuntu:latest

# Update the package list
RUN DEBIAN_FRONTEND=noninteractive apt-get update 

# Upgrade all installed packages to their latest versions
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Set the maintainer label
LABEL maintainer="krishna.vatsavai@hotmail.com"

# Update the package list and install some basic packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -qq --no-install-recommends\
    apt-transport-https \  
    apt-utils \  
    ca-certificates \  
    git \  
    iputils-ping \ 
    jq \ 
    lsb-release \ 
    software-properties-common \  
    curl \  
    wget \ 
    unzip \  
    nano \  
    python3 \  
    python3-pip \ 
    python3-setuptools \  
    nano \  
    python3-dev \  
    unzip \  
    nano  

# Update the package list again
RUN DEBIAN_FRONTEND=noninteractive apt-get update 

# Upgrade all installed packages to their latest versions again
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y   

# Install the Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Powershell
RUN wget http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu72_72.1-3ubuntu3_amd64.deb
RUN dpkg -i libicu72_72.1-3ubuntu3_amd64.deb
RUN wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.4/powershell_7.4.4-1.deb_amd64.deb
RUN dpkg -i powershell_7.4.4-1.deb_amd64.deb
RUN rm powershell_7.4.4-1.deb_amd64.deb


# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update && apt-get install terraform
RUN rm -rf /usr/local/bin/terraform
RUN cp -p /usr/bin/terraform /usr/local/bin/terraform


USER root
RUN apt-get -y update && apt-get install -y curl && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash && az aks install-cli && \
    curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh && \
    mkdir devops-runner && cd devops-runner && \
    curl -o vsts-agent-linux-x64-3.217.1.tar.gz -L https://vstsagentpackage.azureedge.net/agent/3.217.1/vsts-agent-linux-x64-3.217.1.tar.gz && \
    tar xzf ./vsts-agent-linux-x64-3.217.1.tar.gz && \
    apt-get clean

RUN addgroup --gid 110 devops && adduser devops --uid 111 --system && adduser devops devops && \
  chown -R devops:devops devops-runner

USER devops



