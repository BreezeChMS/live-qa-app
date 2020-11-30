#!/bin/sh

prNumber="$(echo -n "$1" | md5sum | sed 's/ .*$//')"
branchName=$2

# Make sure the git repository is updated
cd /docker/repo
git fetch > /dev/null 2>&1

# Create and Start the Docker Compose
cd /docker
cp template.docker-compose.yaml ${prNumber}.docker-compose.yaml
sed -i "s/PR_NUMBER/${prNumber}/g" ${prNumber}.docker-compose.yaml
sed -i "s/BRANCH_NAME/${branchName}/g" ${prNumber}.docker-compose.yaml

if docker-compose -f /docker/${prNumber}.docker-compose.yaml up -d > /dev/null 2>&1; then
    echo '{"status":"success", "url":"https://'${prNumber}'.hopingthis.works"}'
else
    echo '{"status":"failure"}'
fi
