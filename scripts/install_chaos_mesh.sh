#!/usr/bin/env sh

harvester_management_url=$1

COUNT=$(kubectl --kubeconfig kubeconfig.yaml -nchaos-testing get apps chaos-mesh| grep chaos-mesh | wc -l)
if [ $COUNT -gt 0 ]; then
    echo "Chaos-Mesh has already been installed, skip."
else
    TOKEN=$(cat token.txt)
    curl "$harvester_management_url/v1/catalog.cattle.io.clusterrepos/chaos-mesh?action=install" \
    -H 'accept: application/json' \
    -H 'content-type: application/json;charset=UTF-8' \
    -H "cookie: R_PCS=light; R_LOCALE=en-us; R_USERNAME=admin; R_REDIRECTED=true; R_SESS=${TOKEN}" \
    -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36' \
    --data-raw '{"charts":[{"chartName":"chaos-mesh","version":"2.6.1","releaseName":"chaos-mesh","annotations":{"catalog.cattle.io/ui-source-repo-type":"cluster","catalog.cattle.io/ui-source-repo":"chaos-mesh"},"values":{"chaosDaemon":{"runtime":"containerd","socketPath":"/run/k3s/containerd/containerd.sock"},"controllerManager":{"chaosdSecurityMode":false},"global":{"cattle":{"clusterId":"local","clusterName":"local","systemProjectId":"","url":"'$harvester_management_url'","rkePathPrefix":"","rkeWindowsPathPrefix":""}}}}],"noHooks":false,"timeout":"600s","wait":true,"namespace":"chaos-testing","projectId":null,"disableOpenAPIValidation":false,"skipCRDs":false}' \
    --compressed \
    --insecure
fi

# Wait for Chaos-Mesh to be deployed
timeout=300

start_time=$(date +%s)
current_time=$(date +%s)

while [[ $((current_time - start_time)) -lt $timeout ]]; do
    status=$(kubectl --kubeconfig kubeconfig.yaml -nchaos-testing get apps chaos-mesh -ojson | jq --raw-output ".status.summary.state" | awk '{print tolower($0)}')

    if [[ $status == "deployed" ]]; then
        echo "Chaos-Mesh is deployed."
        break
    fi

    sleep 5
    current_time=$(date +%s)
done

if [[ $((current_time - start_time)) -ge $timeout ]]; then
    echo "Timeout reached."
    exit 1
fi