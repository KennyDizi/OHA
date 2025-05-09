#!/bin/bash

# Check if .env file exists
if [ -f .env ]; then
    # Load environment variables from .env file
    export $(cat .env | grep -v '^#' | xargs)

    export WORKSPACE_BASE=$(pwd)
    export SANDBOX_VOLUMES=$(pwd):/workspace:rw

    # Run the Open Hands container
    docker run -it --rm --pull=always \
        -e SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.all-hands.dev/all-hands-ai/runtime:0.37-nikolaik \
        -e LOG_ALL_EVENTS=true \
        -e SANDBOX_USER_ID=$(id -u) \
        -e WORKSPACE_MOUNT_PATH=$WORKSPACE_BASE \
        -e LLM_API_KEY=$LLM_API_KEY \
        -e LLM_PROVIDER=$LLM_PROVIDER \
        -e LLM_MODEL=$LLM_MODEL \
        -e AGENT_MEMORY_ENABLED=$AGENT_MEMORY_ENABLED \
        -e SECURITY_CONFIRMATION_MODE=$SECURITY_CONFIRMATION_MODE \
        -v $WORKSPACE_BASE:/opt/workspace_base \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ~/.openhands-state:/.openhands-state \
        -p 3080:3080 \
        --add-host host.docker.internal:host-gateway \
        --name $CONTAINER_NAME \
        docker.all-hands.dev/all-hands-ai/openhands:0.37 \
        python3 -m openhands.cli.main
else
    echo "Error: .env file not found"
    exit 1
fi
