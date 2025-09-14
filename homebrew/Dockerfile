FROM bitnami/minideb:latest

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

RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    rm -rf /home/user/.cache/* && \
    find /home/linuxbrew/.linuxbrew -name "*.md" -type f -delete && \
    find /home/linuxbrew/.linuxbrew -name "*.txt" -type f -delete && \
    find /home/linuxbrew/.linuxbrew -name "*.rst" -type f -delete && \
    find /home/linuxbrew/.linuxbrew -name "LICENSE*" -type f -delete && \
    find /home/linuxbrew/.linuxbrew -name "README*" -type f -delete && \
    find /home/linuxbrew/.linuxbrew -type d -name "docs" -exec rm -rf {} + 2>/dev/null || true && \
    find /home/linuxbrew/.linuxbrew -type d -name "test" -exec rm -rf {} + 2>/dev/null || true && \
    find /home/linuxbrew/.linuxbrew -type d -name ".git" -exec rm -rf {} + 2>/dev/null || true

ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# Criar a função brew_install como um script
RUN echo '#!/bin/bash\n\
set -e\n\
/home/linuxbrew/.linuxbrew/bin/brew install "$@" && \
rm -rf /home/user/.cache/* && \
rm -rf /home/linuxbrew/.linuxbrew/Homebrew/Cache/* && \
find /home/linuxbrew/.linuxbrew -name "*.md" -type f -delete 2>/dev/null || true && \
find /home/linuxbrew/.linuxbrew -type d -name "docs" -exec rm -rf {} + 2>/dev/null || true && \
find /home/linuxbrew/.linuxbrew -type d -name "test" -exec rm -rf {} + 2>/dev/null || true && \
/home/linuxbrew/.linuxbrew/bin/brew cleanup' \
> /home/linuxbrew/brew_install && \
chmod +x /home/linuxbrew/brew_install

ENV PATH="/home/linuxbrew:${PATH}"

HEALTHCHECK --interval=30s --timeout=3s --start-period=1s --retries=5 \
  CMD /bin/bash -c "echo 'healthy'" || exit 0

CMD ["tail", "-f", "/dev/null"]