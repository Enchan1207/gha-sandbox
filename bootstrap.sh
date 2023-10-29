#!/bin/bash
#
# setup Buildroot image
#

# コマンド確認
required_commands="gh jq"
which $required_commands > /dev/null
if [ $? -ne 0 ]; then
    echo "command requirement not satisfied: $required_commands"
    exit 1
fi

# Buildrootベースイメージを探し、なければpull
baseImageName=enchan1207/buildroot_base
baseImageInfo=`docker images --format json | jq -r "select(.Repository == \"${baseImageName}\")"`
if [ -z "$baseImageInfo" ]; then
    echo "Buildroot base image (${baseImageName}) not found. Try to pull..."
    docker pull $baseImageName > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "An unexpected error occured while pull Buildroot base image."
        exit 1
    fi
fi

# SDKをダウンロード
LATEST_RELEASE_INFO=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    /repos/Enchan1207/rpi-buildroot/releases/latest)
ASSET_URL=`echo $LATEST_RELEASE_INFO | jq -r ".assets_url"`
ASSET_INFO=`curl $ASSET_URL`
SDK_URL=`echo $ASSET_INFO | jq -r ".[] | select(.name == \"sdk.tar.gz\") .browser_download_url"`
wget $SDK_URL

# Dockerイメージをビルド
docker build -t enchan1207/buildroot -f buildroot.Dockerfile . > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "An unexpected error occured while build Buildroot image."
    exit 1
fi

# キャッシュを削除
rm sdk.tar.gz

echo "finished."
