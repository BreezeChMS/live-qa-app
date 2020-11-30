#!/bin/sh

prNumber="$(echo -n "$1" | md5sum | sed 's/ .*$//')"

# Remove the Docker container and delete the assets

if docker-compose -f /docker/${prNumber}.docker-compose.yaml down > /dev/null 2>&1 && rm -f /docker/${prNumber}.docker-compose.yaml; then
    echo '{"status":"success"}'
else
    echo '{"status":"failure"}'
fi