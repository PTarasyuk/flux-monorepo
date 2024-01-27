#!/bin/bash

# Перевірка, чи є встановлено kubectl
if ! command -v kubectl &> /dev/null; then
    echo "kubectl not found. Please install kubectl."
    exit 1
fi

clusters_path="$(readlink -f "$0" | awk -F'scripts/test.sh' '{print $1}')"
clusters=$(ls "${clusters_path}clusters/" | xargs -n 1 basename | tr '\n' ' ')
for cluster in ${clusters}; do
    echo "-------------------------------------------"
    echo "Cluster: ${cluster}"