#!/usr/bin/env sh

harvester_management_url=$1

COUNT=$(kubectl --kubeconfig kubeconfig.yaml get clusterrepo | grep chaos-mesh | wc -l)
if [ $COUNT -gt 0 ]; then
    echo "Chaos-Mesh Repo has already been added, skip."
    exit 0
fi

TOKEN=$(cat token.txt)
curl "$harvester_management_url/v1/catalog.cattle.io.clusterrepos" \
    -H 'accept: application/json' \
    -H 'content-type: application/json' \
    -H "cookie: R_PCS=light; R_LOCALE=en-us; R_USERNAME=admin; R_REDIRECTED=true; R_SESS=${TOKEN}" \
    -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36' \
    --data-raw '{"type":"catalog.cattle.io.clusterrepo","metadata":{"name":"chaos-mesh"},"spec":{"url":"https://charts.chaos-mesh.org","clientSecret":null}}' \
    --compressed \
    --insecure

# Wait for repo to be active
timeout=300

start_time=$(date +%s)
current_time=$(date +%s)

while [[ $((current_time - start_time)) -lt $timeout ]]; do
    COUNT=$(kubectl --kubeconfig kubeconfig.yaml -nchaos-testing get clusterrepo chaos-mesh -ojson | jq --raw-output ".status.conditions[].status" | wc -l)
    if [[ $COUNT -eq 2 ]]; then
        break;
    fi

    sleep 5
    echo "Waiting for repo to be active..."
    current_time=$(date +%s)
done

if [[ $((current_time - start_time)) -ge $timeout ]]; then
    echo "Timeout reached."
    exit 1
fi

sleep 10