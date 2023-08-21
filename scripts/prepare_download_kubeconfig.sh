#!/usr/bin/env sh
set -e

harvester_management_url=$1

TOKEN=$(cat token.txt)
curl "$harvester_management_url/v1/management.cattle.io.clusters/local?action=generateKubeconfig" \
    -X 'POST' \
    -H 'accept: application/json' \
    -H "cookie: R_PCS=light; R_LOCALE=en-us; R_USERNAME=admin; R_REDIRECTED=true; R_SESS=$TOKEN" \
    -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36' \
    --compressed \
    --insecure | jq --raw-output ".config" > kubeconfig.yaml