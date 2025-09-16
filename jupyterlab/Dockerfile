FROM ghcr.io/italoalmeida0/aweci:homebrew AS builder
RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc_immutable

USER user
WORKDIR /home/user

RUN brew_install \
    uv \
    starship
RUN echo 'eval "$(/app/homebrew/bin/starship init bash)"' >> ~/.bashrc_immutable

RUN uv venv --seed .venv
RUN uv pip install jupyterlab
RUN echo 'source /home/user/.venv/bin/activate' >> ~/.bashrc_immutable

FROM bitnami/minideb:latest

RUN install_packages \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg2 \
    htop \
    jq \
    less \
    locales \
    lsb-release \
    nano \
    ncurses-bin \
    openssh-client \
    procps \
    sudo \
    tree \
    unzip \
    vim \
    wget \
    zip

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN groupadd -g 1000 user && \
    useradd -m -u 1000 -g user -s /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY --from=builder --chown=user:user /home/user /app/home
COPY --from=builder --chown=user:user /home/linuxbrew/.linuxbrew /app/homebrew

ENV PATH="/app/homebrew/bin:/app/homebrew/sbin:$PATH"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
ENV PATH="/home/user/.venv/bin:$PATH"

COPY jupyterlab/start.sh /app/start.sh
RUN chmod +x /app/start.sh

COPY .shared/healthcheck.sh /app/healthcheck.sh
RUN chmod +x /app/healthcheck.sh

USER user
WORKDIR /home/user

EXPOSE 8080

ENV HEALTH_ENDPOINT=/lab

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=5 \
    CMD /app/healthcheck.sh

ENTRYPOINT ["/app/start.sh"]
