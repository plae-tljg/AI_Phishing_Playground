FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    git curl openssh-client && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://opencode.ai/install | bash && ln -s /root/.opencode/bin/opencode /usr/local/bin/opencode

WORKDIR /workspace/repo
CMD ["tail", "-f", "/dev/null"]