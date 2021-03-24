#!/bin/bash
# Copyright (c) 2014-2018 Software Architecture Group (Hasso Plattner Institute)
# Copyright (c) 2015 Fabio Niephaus, Google Inc.
# Copyright (c) 2020 Patrick Rein
# Copyright (c) 2021 Tom Beckmann

set -e

function print_info {
    printf "\e[0;34m$1\e[0m\n"
}

DEPLOY_PATH="deploy"
DEPLOY_IMAGE="sandblocks.image"
DEPLOY_CHANGES="sandblocks.changes"
DEPLOY_PACKAGE="sandblocks.zip"
COG_VM_PARAM="-nosound -vm-display-null"

mkdir -p "${DEPLOY_PATH}" 
cd "${DEPLOY_PATH}"

# BASE="Squeak5.3-19458-64bit-202003021730-Linux"
BASE="Squeak5.3-19458-64bit-All-in-One"
BASE_SHARED="$BASE.app"

print_info "Downloading $BASE image..."
wget --no-verbose "http://files.squeak.org/5.3/Squeak5.3-19458-64bit/$BASE.zip"
unzip -q $BASE.zip
rm "$BASE.zip"

# mv $BASE_SHARED/shared/*.image "${DEPLOY_IMAGE}"
# mv $BASE_SHARED/shared/*.changes "${DEPLOY_CHANGES}"
# mv $BASE_SHARED/shared/SqueakV50.sources .

print_info "Preparing $BASE image..."
$BASE_SHARED/Contents/Linux-x86_64/bin/squeak $COG_VM_PARAM "$BASE_SHARED/Contents/Resources/Squeak5.3-19458-64bit.image" "$(pwd)/../scripts/prepare_image.st" || EXIT_STATUS=$?

#print_info "Zipping package ..."
#if [[ $EXIT_STATUS -ne 0 ]]; then
#    zip "${DEPLOY_PACKAGE}" *
#else
#    print_info "Preparation of image file failed."
#fi

exit $EXIT_STATUS
