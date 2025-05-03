FROM ubuntu:22.04

LABEL maintainer="XXXXRT"
LABEL version="V4-0503"
LABEL description="Docker Base image for GPT-SoVITS"

ARG CUDA_VERSION=12.4

ENV CUDA_VERSION=${CUDA_VERSION}

ARG LITE=false
ENV LITE=${LITE}

ARG WORKFLOW=false
ENV WORKFLOW=${WORKFLOW}

SHELL ["/bin/bash", "-c"]

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq 1>/dev/null && \
  apt-get install -y -qq --no-install-recommends \
    wget \
    curl \
    build-essential \
    wget \
    curl \
    unzip \
    git \
    nano \
    htop \
    procps \
    ca-certificates \
    locales \
    libssl-dev \
    libbz2-dev \
    liblzma-dev \
    libreadline-dev \
    libsqlite3-dev \
    zlib1g-dev \
    coreutils \
    util-linux \
    procps \
    1>/dev/null \
    && rm -rf /var/lib/apt/lists/*

RUN du -h --max-depth=3 | sort -hr | head -n 20

ARG WORKFLOW=false
ENV WORKFLOW=${WORKFLOW}

ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM}

ENV HOME="/root"

WORKDIR /workspace

COPY anaconda_install.sh /workspace

RUN bash anaconda_install.sh && rm -rf /workspace/anaconda_install.sh

ENV PATH="$HOME/anaconda3/bin:$PATH"

COPY model_download.sh /workspace

RUN bash model_download.sh && rm -rf /workspace/model_download.sh

RUN du -h --max-depth=4 | sort -hr | head -n 20 && du -h --max-depth=3 /root/anaconda3 | sort -hr | head -n 20 && du -h --max-depth=3 /workspace | sort -hr | head -n 20

