FROM bitnami/minideb:bookworm

RUN install_packages \
    build-essential \
    procps \
    curl \
    file \
    sudo \
    git \
    ca-certificates \
    locales

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN groupadd -g 1000 user && \
    useradd -m -u 1000 -g user -s /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /home/linuxbrew && \
    chown -R user:user /home/linuxbrew

USER user
WORKDIR /home/user

RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

HEALTHCHECK --interval=30s --timeout=3s --start-period=1s --retries=5 \
  CMD /bin/bash -c "echo 'healthy'" || exit 0

CMD ["tail", "-f", "/dev/null"]