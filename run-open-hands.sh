#!/bin/bash

# Check if .env file exists
if [ -f .env ]; then
    # Load environment variables from .env file
    export $(cat .env | grep -v '^#' | xargs)

    # Run the Open Hands container
    docker run -it --rm --pull=always \
        -e SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.all-hands.dev/all-hands-ai/runtime:latest-nikolaik \
        -e LOG_ALL_EVENTS=true \
        -e SANDBOX_USER_ID=$(id -u) \
        -e WORKSPACE_MOUNT_PATH=$WORKSPACE_BASE \
        -e LLM_API_KEY=$LLM_API_KEY \
        -e LLM_MODEL=$LLM_MODEL \
        -v $WORKSPACE_BASE:/opt/workspace_base \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ~/.openhands-state:/.openhands-state \
        -p 3000:3000 \
        --add-host host.docker.internal:host-gateway \
        --name openhands-app-advanced \
        docker.all-hands.dev/all-hands-ai/openhands:latest \
        python -m openhands.core.cli
else
    echo "Error: .env file not found"
    exit 1
fi