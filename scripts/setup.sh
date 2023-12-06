#!/bin/sh

. ./config.sh

cd $EXTERNAL_IOS_LIB_DIR

LIBRANDOMX_PATH=${EXTERNAL_IOS_LIB_DIR}/zephyr/librandomx.a

libtool -static -o libboost.a ./libboost_*.a
libtool -static -o libzephyr.a ./zephyr/*.a
#libtool -static -o libmonero.a ./monero/*.a

CW_ZEPHYR_EXTERNAL_LIB=../../lib
CW_ZEPHYR_EXTERNAL_INCLUDE=../../include

mkdir -p $CW_ZEPHYR_EXTERNAL_INCLUDE
mkdir -p $CW_ZEPHYR_EXTERNAL_LIB

ln ./libboost.a ${CW_ZEPHYR_EXTERNAL_LIB}/libboost.a
ln ./libcrypto.a ${CW_ZEPHYR_EXTERNAL_LIB}/libcrypto.a
ln ./libssl.a ${CW_ZEPHYR_EXTERNAL_LIB}/libssl.a
ln ./libsodium.a ${CW_ZEPHYR_EXTERNAL_LIB}/libsodium.a
ln ./libunbound.a ${CW_ZEPHYR_EXTERNAL_LIB}/libunbound.a
cp ./libzephyr.a $CW_ZEPHYR_EXTERNAL_LIB
#cp ./libmonero.a $CW_ZEPHYR_EXTERNAL_LIB


#cp ../include/zephyr/* $CW_ZEPHYR_EXTERNAL_INCLUDE