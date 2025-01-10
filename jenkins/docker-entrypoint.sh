#!/usr/bin/env bash

dockerd &

for i in {1..10}; do
    docker version > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Docker daemon is up and running."
        break
    fi
    echo "Waiting for Docker daemon to start..."
    sleep 2
done

exec /usr/local/bin/jenkins-agent "$@"