FROM debian:13.1-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    procps \
    curl \
    file \
    sudo \
    git \
    ca-certificates \
    apt-transport-https \
    locales \
    && rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN groupadd -g 1000 user && \
    useradd -m -u 1000 -g user -s /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /home/linuxbrew && \
    chown -R user:user /home/linuxbrew

USER user
WORKDIR /home/user

RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"