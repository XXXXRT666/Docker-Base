FROM ubuntu:22.04

LABEL maintainer="XXXXRT"
LABEL version="V2P-0217"
LABEL description="Docker Base image for GPT-SoVITS"

ARG CUDA_VERSION=12.6

ENV CUDA_VERSION=${CUDA_VERSION}

ARG LITE=false
ENV LITE=${LITE}

ARG WORKFLOW=false
ENV WORKFLOW=${WORKFLOW}

SHELL ["/bin/bash", "-c"]

RUN cat /etc/apt/sources.list

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  apt-get install -y --no-install-recommends \
    wget \
    build-essential \
    curl \
    git \
    htop \
    ca-certificates \
    locales \
    coreutils \
    util-linux \
    procps \
    && rm -rf /var/lib/apt/lists/*

RUN du -h --max-depth=3 | sort -hr | head -n 20

ARG WORKFLOW=false
ENV WORKFLOW=${WORKFLOW}

ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM}

ENV HOME="/root"

WORKDIR /workspace

COPY . /workspace

RUN ls . && echo "1" && ls /workspace

RUN bash miniforge_install.sh && rm -rf /workspace/*

ENV PATH="$HOME/conda/bin:$PATH"

RUN echo $LD_LIBRARY_PATH

ENV LD_LIBRARY_PATH="/root/conda/lib/python3.12/site-packages/nvidia/cudnn/lib:$LD_LIBRARY_PATH"

ENV LD_LIBRARY_PATH="/root/conda/lib/python3.12/site-packages/nvidia/cublas/lib:$LD_LIBRARY_PATH"

COPY model_download.sh /workspace

RUN bash model_download.sh && rm -rf /workspace/model_download.sh

RUN du -h --max-depth=3 | sort -hr | head -n 20 && du -h --max-depth=4 /root/conda | sort -hr | head -n 20 && du -h --max-depth=3 /workspace | sort -hr | head -n 20 && du -h /root/conda/lib/python3.12/site-packages --max-depth=1 | sort -hr | head -n 20

