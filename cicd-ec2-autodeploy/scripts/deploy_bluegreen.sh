#!/usr/bin/env bash
set -euo pipefail

# Expected env vars:
# IMAGE_FULL  (e.g. docker.io/<user>/cicd-ec2-autodeploy:build-123)
# APP_VERSION (e.g. build-123)

APP_DIR="/opt/cicd-ec2-autodeploy"
NGINX_CONF="${APP_DIR}/docker/nginx.conf"

mkdir -p "${APP_DIR}"
cd "${APP_DIR}"

# If first time: put repo runtime files here
# You can git clone on EC2 OR Jenkins will scp needed files. We keep it simple:
# We assume docker-compose.ec2.yml and docker/nginx.conf exist in APP_DIR.

if [[ ! -f docker.ec2.yml ]]; then
    echo "ERROR: docker.ec2.yml not found in ${APP_DIR}"
    exit 1
fi

echo "Pulling image: ${IMAGE_FULL}"
sudo docker pull "${IMAGE_FULL}"

# Bring up both slots (blue+green) with latest image tag (both run same image, switch decides live traffic)
export IMAGE_FULL APP_VERSION
sudo docker compose -f docker-compose.ec2.yml up -d

# Determine currently active upstream in nginx.conf
ACTIVE_UPSTREAM="$(grep -E 'proxy_pass http://127\.0\.0\.1:808[12];' -o "${NGINX_CONF}" | tail -n 1 || true)"

if [[ "${ACTIVE_UPSTREM} == *"8081"*" ]]; then
   NEW_PORT="8082"
   NEW_SLOT="green"
else
   NEW_PORT="8081"
   NEW_SLOT="blue"
fi

echo "Switching traffic to ${NEW_SLOT} (port ${NEW_PORT})"

# Basic health check loop in new slot
for i in {1..10}; do
  if curl -fss "http://127.0.0.1:${NEW_PORT}/health" >/dev/null; then
    echo "New slot healthy"
    break
  fi
  echo "waiting for new slot health... ${i}/10"
  sleep 2
  if [[ $i -eq 20]]; then
    echo "ERROR: New slot did not become healthy"
    exit 1
  fi
Done

# Swap nginx upstream and reload
sudo sed -i "s#proxy_pass http://127.0.0.1:808[12];#proxy_pass http://127.0.0.1:${NEW_PORT};#g" "${NGINX_CONF}"
sudo docker exec edge-nginx nginx -s reload

echo "Deploy complete. Live traffic now on port ${NEW_PORT} via Nginx:80"

