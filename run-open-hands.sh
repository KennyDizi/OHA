#!/bin/bash

# Check if .env file exists
if [ -f .env ]; then
    # Load environment variables from .env file
    export $(cat .env | grep -v '^#' | xargs)

    # Only pass CORE_REASONING_EFFORT to Docker if it is set/non-empty
    CORE_REASONING_EFFORT_ARG=""
    if [[ -n "$CORE_REASONING_EFFORT" ]]; then
        CORE_REASONING_EFFORT_ARG="-e CORE_REASONING_EFFORT=${CORE_REASONING_EFFORT}"
    fi

    # Display what will actually be passed to Docker
    if [[ -n "$CORE_REASONING_EFFORT_ARG" ]]; then
        echo "CORE_REASONING_EFFORT_ARG=$CORE_REASONING_EFFORT_ARG"
    fi

    export SANDBOX_VOLUMES=$(pwd):/workspace:rw
    export RUNTIME_MOUNT=$(pwd):/workspace:rw

    # Run the Open Hands container
    docker run -it --rm --pull=always \
        -e SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.all-hands.dev/all-hands-ai/runtime:0.38-nikolaik \
        -e LOG_ALL_EVENTS=true \
        -e SANDBOX_USER_ID=$(id -u) \
        -e RUNTIME_MOUNT=$RUNTIME_MOUNT \
        -e LLM_API_KEY=$LLM_API_KEY \
        -e LLM_PROVIDER=$LLM_PROVIDER \
        -e LLM_MODEL=$LLM_MODEL \
        -e AGENT_MEMORY_ENABLED=$AGENT_MEMORY_ENABLED \
        -e LLM_CACHING_PROMPT=$LLM_CACHING_PROMPT \
        -e AGENT_ENABLE_THINK=$AGENT_ENABLE_THINK \
        -e LLM_NUM_RETRIES=$LLM_NUM_RETRIES \
        -e SANDBOX_VOLUMES=$SANDBOX_VOLUMES \
        $CORE_REASONING_EFFORT_ARG \
        -e CORE_PLATFORM=$CORE_PLATFORM \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ~/.openhands-state:/.openhands-state \
        -p 3080:3080 \
        --add-host host.docker.internal:host-gateway \
        --name $CONTAINER_NAME \
        docker.all-hands.dev/all-hands-ai/openhands:0.38 \
        python3 -m openhands.cli.main
else
    echo "Error: .env file not found"
    exit 1
fi
