ARG BUILD_FROM=ghcr.io/hassio-addons/ubuntu-base/aarch64:8.1.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

ARG TARGETPROC=arm64
# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-${TARGETPROC}
WORKDIR /azp

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
  set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    git \
    iputils-ping \
    lsb-release \
    software-properties-common \
    unzip \
    zip \
  && rm -fr \
      /root/.cache \
      /tmp/* \
      /var/{cache,log}/* \
      /var/lib/apt/lists/*

# Install Azure-CLI v2.37.0
RUN apt-get update \
  && apt-get install -y -qq --no-install-recommends \
    gnupg \
    python3.8-dev \
    python3-pip \
    gcc \
  && pip3 install --no-cache-dir --upgrade pip --force \
  && pip3 install --no-cache-dir azure-cli==2.37.0 \
  && apt-get remove -y python3-pip \
  && apt-get autoremove -y \
  && rm -fr \
      /root/.cache \
      /tmp/* \
      /var/{cache,log}/* \
      /var/lib/apt/lists/*

# Downloading and installing Powershell for specified targetproc (linux-x64 per default)
RUN curl -L -o /tmp/powershell.tar.gz "https://github.com/PowerShell/PowerShell/releases/download/v7.2.4/powershell-7.2.4-${TARGETARCH}.tar.gz" \
  && mkdir -p /opt/microsoft/powershell/7 \
  && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 \
  && chmod +x /opt/microsoft/powershell/7/pwsh \
  && ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh \
  && rm -fr /root/.cache /tmp/* /var/{cache,log}/* /var/lib/apt/lists/*

# Install Azure Powershell Module v8.0.0
RUN /usr/bin/pwsh -Command Set-PSRepository -Name PSGallery -InstallationPolicy Trusted \
  && /usr/bin/pwsh -Command Install-Module -Name Az -RequiredVersion 8.0.0 -Scope AllUsers \
  && rm -fr /root/.cache /tmp/* /var/{cache,log}/* /var/lib/apt/lists/*

# Create Python3.8.10 tool directory, upgrade pip
# hadolint ignore=SC1091
RUN apt-get update \
  && apt-get install -y -qq --no-install-recommends \
    python3.8-venv \
  && mkdir -p /azp/_work/_tool/Python/3.8.10 \
  && cd /azp/_work/_tool/Python/3.8.10 \
  && python3.8 -m venv x64 \
  && touch x64.complete \
  && . /azp/_work/_tool/Python/3.8.10/x64/bin/activate \
  && pip3 install --no-cache-dir --upgrade pip \
  && deactivate \
  && rm -fr \
      /root/.cache \
      /tmp/* \
      /var/{cache,log}/* \
      /var/lib/apt/lists/*

# Create Python3.9.5 tool directory, upgrade pip
# hadolint ignore=SC1091
RUN apt-get update \
  && apt-get install -y -qq --no-install-recommends \
    python3.9-dev \
    python3.9-venv \
  && mkdir -p /azp/_work/_tool/Python/3.9.5 \
  && cd /azp/_work/_tool/Python/3.9.5 \
  && python3.8 -m venv x64 \
  && touch x64.complete \
  && . /azp/_work/_tool/Python/3.9.5/x64/bin/activate \
  && pip3 install --no-cache-dir --upgrade pip \
  && deactivate \
  && rm -fr \
      /root/.cache \
      /tmp/* \
      /var/{cache,log}/* \
      /var/lib/apt/lists/*

COPY /rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_VERSION
ARG BUILD_DATE
ARG BUILD_REPOSITORY
ARG BUILD_REF


# Labels
LABEL \
  io.hass.name="${BUILD_NAME}" \
  io.hass.description="${BUILD_DESCRIPTION}" \
  io.hass.arch="${BUILD_ARCH}" \
  io.hass.type="addon" \
  io.hass.version=${BUILD_VERSION} \
  maintainer="Matthias Wild <mauwii@outlook.de>" \
  org.opencontainers.image.authors="Matthias Wild <mauwii@outlook.de>" \
  org.opencontainers.image.created=${BUILD_DATE} \
  org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
  org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-ubuntu-base/blob/main/README.md" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.revision=${BUILD_REF} \
  org.opencontainers.image.source="https://github.com/mauwii/ha-devops-agent" \
  org.opencontainers.image.title="${BUILD_NAME}" \
  org.opencontainers.image.url="https://github.com/mauwii/HA-DevOps-Agent.git" \
  org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
  org.opencontainers.image.version=${BUILD_VERSION}
