ARG CUDA_VERSION=12.4
ARG CUDA_BASE=runtime

FROM nvidia/cuda:${CUDA_VERSION}.1-cudnn-${CUDA_BASE}-ubuntu22.04

LABEL maintainer="XXXXRT"
LABEL version="V4-0501"
LABEL description="Docker Base image for GPT-SoVITS"

ARG CUDA_VERSION=12.4

ENV CUDA_VERSION=${CUDA_VERSION}

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq 1>/dev/null && \
  apt-get install -y -qq --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    wget \
    curl \
    unzip \
    git \
    nano \
    htop \
    procps \
    ca-certificates \
    locales \
    1>/dev/null \
    && rm -rf /var/lib/apt/lists/*

ARG WORKFLOW=false
ENV WORKFLOW=${WORKFLOW}

ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM}

ENV HOME="/root"

COPY anaconda_install.sh /workspace

RUN bash anaconda_install.sh && rm -rf /workspace/anaconda_install.sh

SHELL ["/bin/bash", "-c"]
