#!/usr/bin/env bash

mkdir -p /build
cd /build
git clone $TCLSCAN_REPO
patch -p0 < tclscan.patch
cd /build/tclscan
cargo install --path .
cp -f /root/.cargo/bin/tclscan /usr/bin/

# basic tests
echo -n 'expr 1+1' | tclscan check - | grep ^WARNING >/dev/null || exit 1
echo -n 'expr {1+1}' | tclscan check - | grep ^WARNING >/dev/null && exit 1

cd /

rm -rf /build/tclscan /root/.cargo
