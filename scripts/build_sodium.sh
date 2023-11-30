#!/bin/sh

. ./config.sh

SODIUM_PATH="${EXTERNAL_IOS_SOURCE_DIR}/libsodium"
SODIUM_URL="https://github.com/jedisct1/libsodium.git"

echo "============================ SODIUM ============================"

echo "Cloning SODIUM from - $SODIUM_URL"
git clone $SODIUM_URL $SODIUM_PATH --branch stable
cd $SODIUM_PATH
./dist-build/apple-xcframework.sh

mv ${SODIUM_PATH}/libsodium-apple/ios/include/* $EXTERNAL_IOS_INCLUDE_DIR
mv ${SODIUM_PATH}/libsodium-apple/ios/lib/* $EXTERNAL_IOS_LIB_DIR

#mv ${SODIUM_PATH}/libsodium-apple/ios-simulators/include/* $EXTERNAL_IOS_INCLUDE_DIR
#mv ${SODIUM_PATH}/libsodium-apple/ios-simulators/lib/* $EXTERNAL_IOS_LIB_DIR