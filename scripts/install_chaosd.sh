#!/usr/bin/env sh

chasod_port=$1

COUNT=$(ps aux | grep "chaosd server" | grep -v grep | wc -l)
if [ $COUNT -gt 0 ]; then
    echo "Chaosd has already been launched, skip."
    exit 0
fi

export CHAOSD_VERSION=v1.4.0

mkdir -p chaosd
cd chaosd

if [ ! -f "$myFile" ]; then
    curl -fsSLO https://mirrors.chaos-mesh.org/chaosd-$CHAOSD_VERSION-linux-amd64.tar.gz
fi

tar zxvf chaosd-$CHAOSD_VERSION-linux-amd64.tar.gz && sudo mv chaosd-$CHAOSD_VERSION-linux-amd64 /usr/local/
export PATH=/usr/local/chaosd-$CHAOSD_VERSION-linux-amd64:$PATH
nohup chaosd server --port $chasod_port > chaosd.log 2>&1 &