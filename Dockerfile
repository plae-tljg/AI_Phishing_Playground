FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    git curl openssh-client python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --break-system-packages requests python-dotenv anthropic

RUN curl -fsSL https://opencode.ai/install | bash \
    && ln -s /root/.opencode/bin/opencode /usr/local/bin/opencode

COPY opencode.jsonc /root/
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /workspace/repo
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
