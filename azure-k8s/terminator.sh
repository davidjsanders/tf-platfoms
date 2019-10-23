#!/usr/bin/env bash
echo
echo "Draining and removing kubernetes worker nodes not in: ${workers}"
echo
workers="${workers}"
oldworkers="$(kubectl get nodes -o json | jq -r '.items[].metadata.labels | select(.role == "worker") ' | jq -r '."kubernetes.io/hostname"')"
for w in $oldworkers
do
    temp="$(echo $workers | grep $w)"
    ret_stat="$?"
    if [ "$ret_stat" == "0" ]
    then
        echo "$w found. Leave alone"
    else
        echo "$w not found. Draining"
        kubectl drain $w --ignore-daemonsets
        echo "Wait for node to drain - 60s"
        sleep 60
        echo "Delete node $w"
        kubectl delete node $w
    fi
done
