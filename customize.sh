#!/system/bin/sh

SKIPUNZIP=0

uid=$(ls -n /data/data | grep "com.guoshi.httpcanary" | awk '{print $3}')
if [ -z "$uid" ]; then
    uid=$(dumpsys package com.guoshi.httpcanary | grep userId | sed '$d;s/[^0-9]//g')
fi

if [ -z "$uid" ]; then
    abort "HttpCanary not found"
fi

if [ -z "$MODPATH" ]; then
    MODPATH="."
fi

# https://stackoverflow.com/questions/67627193/how-to-install-httpcanary-certificate-on-android-11-without-root/68229133#68229133
CADIR=$MODPATH/system/etc/security/cacerts
CA=$CADIR/87bc3517.0
mkdir -p $CADIR
cp -f /data/data/com.guoshi.httpcanary/cache/HttpCanary.pem $CA
chmod 644 $CA
touch /data/data/com.guoshi.httpcanary/cache/HttpCanary.jks
chown -R $uid:$uid /data/data/com.guoshi.httpcanary/cache
