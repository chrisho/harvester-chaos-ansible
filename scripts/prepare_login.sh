#!/usr/bin/env sh
set -e

harvester_management_url=$1
harvester_username=$2
harvester_password=$3

curl "$harvester_management_url/v3-public/localProviders/local?action=login" \
          --data-raw "{\"description\":\"UI session\",\"responseType\":\"json\",\"username\":\"$harvester_username\",\"password\":\"$harvester_password\"}" \
          --compressed \
          --insecure | jq --raw-output ".token" > token.txt 