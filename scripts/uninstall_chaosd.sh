#!/usr/bin/env sh

COUNT=$(ps aux | grep "chaosd server" | grep -v grep | wc -l)
if [ $COUNT -gt 0 ]; then
   kill -9 $(ps aux | grep "chaosd server" | grep -v grep | awk '{print $2}')
fi