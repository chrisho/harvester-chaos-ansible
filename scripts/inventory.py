#!/usr/bin/env python3

import subprocess
import json

# Get Nodes
nodes_ip = (
    subprocess.check_output(
        ["kubectl", "--kubeconfig", "kubeconfig.yaml",
            "get",
            "nodes",
            "-ojson"],
        text=True
    )
    .strip()
)
nodes_data = json.loads(nodes_ip)
nodes = nodes_data["items"]

# Get Nodes IP
nodes_ips = [node["status"]["addresses"][0]["address"] for node in nodes]

# Generate JSON Inventory manifest
output = {
    "_meta": {
        "hostvars": {}
    },
    "all": {
        "children": [
            "harvester"
        ]
    },
    "harvester": {
        "hosts": nodes_ips
    }
}

print(json.dumps(output, indent=2))
