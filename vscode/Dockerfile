FROM debian:13.1-slim AS builder

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    git \
    wget \
    unzip \
    build-essential \
    file \
    sudo \
    locales \
    && rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN pip3 install --break-system-packages uv

RUN groupadd -g 1000 user && \
    useradd -m -u 1000 -g user -s /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER user
WORKDIR /home/user

RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

RUN /home/linuxbrew/.linuxbrew/bin/brew install starship

RUN uv venv --seed .venv

RUN echo 'eval "$(/app/homebrew/bin/starship init bash)"' >> ~/.bashrc_immutable
RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc_immutable
RUN echo 'source /home/user/.venv/bin/activate' >> ~/.bashrc_immutable

FROM debian:13.1-slim

RUN apt-get update && apt-get install -y \
    python3 \
    sudo \
    apt-transport-https \
    gnupg2 \
    lsb-release \
    curl \
    git \
    openssh-client \
    wget \
    unzip \
    vim \
    ca-certificates \
    locales \
    procps \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Docker CLI
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli docker-compose-plugin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# VSCode
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg && \
    install -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list && \
    rm /tmp/packages.microsoft.gpg && \
    apt-get update && \
    apt-get install -y code && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN groupadd -g 1000 user && \
    useradd -m -u 1000 -g user -s /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY --from=builder --chown=user:user /home/user /app/home
COPY --from=builder --chown=user:user /home/linuxbrew/.linuxbrew /app/homebrew

ENV PATH="/app/homebrew/bin:/app/homebrew/sbin:$PATH"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
ENV PATH="/home/user/.venv/bin:$PATH"

COPY vscode/start.sh /app/start.sh
RUN chmod +x /app/start.sh

COPY .shared/healthcheck.sh /app/healthcheck.sh
RUN chmod +x /app/healthcheck.sh

USER user
WORKDIR /home/user

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=5 \
    CMD /app/healthcheck.sh

ENTRYPOINT ["/app/start.sh"]