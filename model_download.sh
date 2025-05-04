#!/bin/bash

cd /workspace || exit

set -e

mkdir models

WORKFLOW=${WORKFLOW:-"false"}
LITE=${LITE:-"false"}

if [ "$WORKFLOW" = "true" ]; then
    WGET_CMD="wget -nv --tries=25 --wait=5 --read-timeout=40 --retry-on-http-error=404"
else
    WGET_CMD="wget --tries=25 --wait=5 --read-timeout=40 --retry-on-http-error=404"
fi

DOWNLOAD_FUNASR=false
DOWNLOAD_FASTERWHISPER=false
DOWNLOAD_UVR5=false

if [ "$LITE" = "true" ]; then
    DOWNLOAD_FUNASR=false
    DOWNLOAD_FASTERWHISPER=false
    DOWNLOAD_UVR5=false
else
    DOWNLOAD_FUNASR=true
    DOWNLOAD_FASTERWHISPER=true
    DOWNLOAD_UVR5=true
fi

mkdir /workspace/models/pretrained_models
mkdir /workspace/models/asr_models
mkdir /workspace/models/uvr5_weights

if [ "$DOWNLOAD_FUNASR" = "true" ]; then
    echo "Downloading funasr..."
    $WGET_CMD "https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/funasr.zip"
    unzip -q funasr.zip -d /workspace/models/asr_models
    rm -rf funasr.zip
fi

if [ "$DOWNLOAD_FASTERWHISPER" = "true" ]; then
    echo "Downloading faster-whisper-v3-large..."
    $WGET_CMD "https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/faster-whisper.zip"
    unzip -q faster-whisper.zip -d /workspace/models/asr_models
    rm -rf faster-whisper.zip
fi

if [ "$DOWNLOAD_UVR5" = "true" ]; then
    echo "Downloading uvr5 weight..."
    $WGET_CMD "https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/uvr5_weights.zip"
    unzip -q uvr5_weights.zip
    rm -rf uvr5_weights.zip
    mv uvr5_weights/* /workspace/models/uvr5_weights
    rm -rf uvr5_weights
fi

PRETRINED_URL="https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/pretrained_models.zip"
G2PW_URL="https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/G2PWModel.zip"

$WGET_CMD "$PRETRINED_URL"

unzip -q pretrained_models.zip
rm -rf pretrained_models.zip
mv pretrained_models/* /workspace/models/pretrained_models
rm -rf pretrained_models

$WGET_CMD "$G2PW_URL"

unzip -q G2PWModel.zip
rm -rf G2PWModel.zip
mv G2PWModel /workspace/models
