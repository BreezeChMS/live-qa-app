#!/bin/sh

prNumber="$(echo -n "$1" | md5sum | sed 's/ .*$//')"

# Pull in new changes

if docker-compose -f /docker/${prNumber}.docker-compose.yaml exec -T web git pull > /dev/null 2>&1; then
    echo '{"status":"success", "url":"https://'${prNumber}'.hopingthis.works"}'
else
    echo '{"status":"failure"}'
fi