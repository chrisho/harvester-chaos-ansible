# harvester-chaos-ansible

## Installation

### Prepare Install
```bash
ansible-playbook -e "@settings.yml" prepare-install.yml
```

### Install Chaos Mesh
```bash
ansible-playbook -e "@settings.yml" -i scripts/inventory.py install-chaos-mesh.yml
```

### Uninstall 
```bash
ansible-playbook -e "@settings.yml" -i scripts/inventory.py uninstall-chaos-mesh.yml
```

## Run Chaos Experiments

### Bandwidth
```bash
# apply
ansible-playbook -e "@settings.yml" -i scripts/inventory.py experiment/chaosd-bandwidth.yml

# delete
ansible-playbook -e "@settings.yml" -i scripts/inventory.py experiment/chaosd-bandwidth-delete.yml
```