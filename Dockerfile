FROM ghcr.io/open-education-hub/openedu-builder:0.5.1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install system, Python, Node.js, and npm-based tools.
RUN apt-get update && \
    apt-get install -yqq --no-install-recommends \
        ca-certificates \
        curl \
        ffmpeg \
        make && \
    pip install --no-cache-dir MarkdownPP==1.5.1 && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update && \
    apt-get install -yqq --no-install-recommends nodejs && \
    npm install --global reveal-md@6.1.4 && \
    npm cache clean --force && \
    rm -rf /var/lib/apt/lists/*

# Constrain dependencies installed later by openedu-builder through npx.
ENV npm_config_before=2024-06-01T00:00:00.000Z

WORKDIR /content

ENTRYPOINT ["oe_builder"]