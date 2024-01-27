#!/bin/bash

clusters_path="$(readlink -f "$0" | awk -F'scripts/test-podinfo.sh' '{print $1}')"
clusters=$(ls "${clusters_path}clusters/" | xargs -n 1 basename | tr '\n' ' ')
for cluster in ${clusters}; do
    context="kind-${cluster}"
    kubectl --context="$context" -n ingress-nginx port-forward svc/ingress-nginx-controller 8080:80 > /dev/null 2>&1 &
    pid=$!
    timeout=2
    elapsed_time=0
    is_ok=false
    while [ $elapsed_time -lt $timeout ]; do
        if nc -z localhost 8080 2>/dev/null; then
            is_ok=true
            break
        fi
        sleep 1
        ((elapsed_time++))
    done

    if [ $is_ok ]; then
        # DO
        echo "Команда успішно запущена. Ваші інші дії тут."
    else
        echo "Не вдалося запустити команду протягом $timeout секунд."
    fi
    if ps -p $pid > /dev/null; then
        kill $pid > /dev/null 2>&1
        sleep 1
    fi
done
