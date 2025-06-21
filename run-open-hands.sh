#!/bin/bash

# Check if .env file exists
if [ -f .env ]; then
    # Load environment variables from .env file
    export $(cat .env | grep -v '^#' | xargs)

    # ---------- guarantee a deterministic container name ----------
    : "${CONTAINER_NAME:=oha-container}"   # default if .env omits it
    # ----------------------------------------------------------------

    # Only pass REASONING_EFFORT to Docker if it is set/non-empty
    REASONING_EFFORT_ARG=""
    if [[ -n "$REASONING_EFFORT" ]]; then
        REASONING_EFFORT_ARG="-e REASONING_EFFORT=${REASONING_EFFORT}"
    fi

    # Display selected model & reasoning-effort (only when an effort was supplied)
    if [[ -n "$REASONING_EFFORT_ARG" ]]; then
        echo "Using model: ${LLM_MODEL} with reasoning effort: ${REASONING_EFFORT}"
    fi

    export SANDBOX_VOLUMES=$(pwd):/workspace:rw
    export RUNTIME_MOUNT=$(pwd):/workspace:rw

    # ------------------------------------------------------------------
    # Ensure the dedicated Docker network exists
    if ! docker network ls --format '{{.Name}}' | grep -q '^oha-network$'; then
        echo "Creating Docker network 'oha-network'"
        docker network create oha-network
    fi
    # ------------------------------------------------------------------

    # Run the Open Hands container
    docker run -it --rm --pull=always \
        -e SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.all-hands.dev/all-hands-ai/runtime:0.45.0-nikolaik \
        -e LOG_ALL_EVENTS=true \
        -e SANDBOX_USER_ID=$(id -u) \
        -e SANDBOX_VOLUMES=$SANDBOX_VOLUMES \
        -e RUNTIME_MOUNT=$RUNTIME_MOUNT \
        -e LLM_API_KEY=$LLM_API_KEY \
        -e LLM_PROVIDER=$LLM_PROVIDER \
        -e LLM_MODEL=$LLM_MODEL \
        -e AGENT_MEMORY_ENABLED=$AGENT_MEMORY_ENABLED \
        -e LLM_CACHING_PROMPT=$LLM_CACHING_PROMPT \
        -e AGENT_ENABLE_THINK=$AGENT_ENABLE_THINK \
        -e LLM_NUM_RETRIES=$LLM_NUM_RETRIES \
        -e AGENT_ENABLE_MCP=$AGENT_ENABLE_MCP \
        $REASONING_EFFORT_ARG \
        -e PLATFORM=$PLATFORM \
        -e SEARCH_API_KEY=$SEARCH_API_KEY \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ~/.openhands:/.openhands \
        -v $RUNTIME_MOUNT \
        -w /workspace \
        -p 3080:3080 \
        --add-host host.docker.internal:host-gateway \
        --network oha-network \
        --name "${CONTAINER_NAME}" \
        docker.all-hands.dev/all-hands-ai/openhands:0.45.0 \
        python3 -m openhands.cli.main --override-cli-mode true
else
    echo "Error: .env file not found"
    exit 1
fi
