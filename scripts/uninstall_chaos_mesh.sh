#!/usr/bin/env sh

harvester_management_url=$1

TOKEN=$(cat token.txt)
curl $harvester_management_url'/v1/catalog.cattle.io.apps/chaos-testing/chaos-mesh?action=uninstall' \
    -H 'accept: application/json' \
    -H 'content-type: application/json;charset=UTF-8' \
    -H "cookie: R_PCS=light; R_LOCALE=en-us; R_USERNAME=admin; R_REDIRECTED=true; R_SESS=${TOKEN}" \
    -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36' \
    --data-raw '{}' \
    --compressed \
--insecure
kubectl --kubeconfig kubeconfig.yaml -n chaos-testing delete configmap chaos-mesh
kubectl --kubeconfig kubeconfig.yaml delete ns chaos-testing
kubectl --kubeconfig kubeconfig.yaml delete clusterrepos chaos-mesh