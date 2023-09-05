#!/usr/bin/env sh

chaosd_port=$1
export CHAOSD_VERSION=v1.4.0

COUNT=$(ps aux | grep "chaosd server" | grep -v grep | wc -l)
if [ $COUNT -gt 0 ]; then
   kill -9 $(ps aux | grep "chaosd server" | grep -v grep | awk '{print $2}')
fi

mkdir -p chaosd
cd chaosd

if [ ! -f "$myFile" ]; then
    curl -fsSLO https://mirrors.chaos-mesh.org/chaosd-$CHAOSD_VERSION-linux-amd64.tar.gz
fi

tar zxvf chaosd-$CHAOSD_VERSION-linux-amd64.tar.gz && sudo mv chaosd-$CHAOSD_VERSION-linux-amd64 /usr/local/
export PATH=/usr/local/chaosd-$CHAOSD_VERSION-linux-amd64:$PATH
nohup chaosd server --port $chaosd_port > chaosd.log 2>&1 &