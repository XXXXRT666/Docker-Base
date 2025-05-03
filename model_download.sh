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

USE_FUNASR=false
USE_FASTERWHISPER=false

if [ "$LITE" = "true" ]; then
    USE_FUNASR=true
    USE_FASTERWHISPER=false
else
    USE_FUNASR=true
    USE_FASTERWHISPER=true
fi

mkdir /workspace/models/asr_models

if [ "$USE_FUNASR" = "true" ]; then
    echo "Downloading funasr..."
    $WGET_CMD "https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/funasr.zip"
    unzip -q funasr.zip -d /workspace/models/asr_models
    rm -rf funasr.zip
fi

if [ "$USE_FASTERWHISPER" = "true" ]; then
    echo "Downloading faster-whisper..."
    $WGET_CMD "https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/faster-whisper.zip"
    unzip -q faster-whisper.zip -d /workspace/models/asr_models
    rm -rf faster-whisper.zip
fi

mkdir /workspace/models/pretrained_models
mkdir /workspace/models/uvr5_weights

PRETRINED_URL="https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/pretrained_models.zip"
G2PW_URL="https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/G2PWModel.zip"
UVR5_URL="https://huggingface.co/XXXXRT/GPT-SoVITS-Pretrained/resolve/main/uvr5_weights.zip"

$WGET_CMD "$PRETRINED_URL"

unzip -q pretrained_models.zip
rm -rf pretrained_models.zip
mv pretrained_models/* /workspace/models/pretrained_models
rm -rf pretrained_models

$WGET_CMD "$G2PW_URL"

unzip -q G2PWModel.zip
rm -rf G2PWModel.zip
mv G2PWModel /workspace/models

$WGET_CMD "$UVR5_URL"

unzip -q uvr5_weights.zip
rm -rf uvr5_weights.zip
mv uvr5_weights/* /workspace/models/uvr5_weights
rm -rf uvr5_weights
