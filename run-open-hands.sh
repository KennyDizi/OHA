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

    # Print out environment variables that are passed to docker
    echo "--- Passing the following environment variables to Docker ---"
    print_var() {
        local name="$1"
        local value="$2"
        if [ -z "$value" ]; then return; fi
        # Convert name to lowercase for case-insensitive check, using tr for portability
        local lower_name
        lower_name=$(echo "$name" | tr '[:upper:]' '[:lower:]')
        # Check for sensitive keywords in the variable name
        if [[ "$lower_name" == *key* || "$lower_name" == *secret* ]]; then
            echo "${name}=${value:0:6}***"
        else
            echo "${name}=${value}"
        fi
    }
    print_var "SANDBOX_RUNTIME_CONTAINER_IMAGE" "docker.all-hands.dev/all-hands-ai/runtime:0.46.0-nikolaik"
    print_var "LOG_ALL_EVENTS" "true"
    print_var "SANDBOX_USER_ID" "$(id -u)"
    print_var "SANDBOX_VOLUMES" "$SANDBOX_VOLUMES"
    print_var "RUNTIME_MOUNT" "$RUNTIME_MOUNT"
    print_var "LLM_API_KEY" "$LLM_API_KEY"
    print_var "LLM_PROVIDER" "$LLM_PROVIDER"
    print_var "LLM_MODEL" "$LLM_MODEL"
    print_var "AGENT_MEMORY_ENABLED" "$AGENT_MEMORY_ENABLED"
    print_var "LLM_CACHING_PROMPT" "$LLM_CACHING_PROMPT"
    print_var "AGENT_ENABLE_THINK" "$AGENT_ENABLE_THINK"
    print_var "LLM_NUM_RETRIES" "$LLM_NUM_RETRIES"
    print_var "AGENT_ENABLE_MCP" "$AGENT_ENABLE_MCP"
    print_var "REASONING_EFFORT" "$REASONING_EFFORT"
    print_var "SANDBOX_PLATFORM" "$SANDBOX_PLATFORM"
    print_var "SANDBOX_ENABLE_GPU" "$SANDBOX_ENABLE_GPU"
    print_var "SEARCH_API_KEY" "$SEARCH_API_KEY"
    echo "-----------------------------------------------------------"

    # Run the Open Hands container
    docker run -it --rm --pull=always \
        -e SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.all-hands.dev/all-hands-ai/runtime:0.46.0-nikolaik \
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
        -e SANDBOX_PLATFORM=$SANDBOX_PLATFORM \
        -e SANDBOX_ENABLE_GPU=$SANDBOX_ENABLE_GPU \
        -e SEARCH_API_KEY=$SEARCH_API_KEY \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ~/.openhands:/.openhands \
        -v $RUNTIME_MOUNT \
        -w /workspace \
        -p 3080:3080 \
        --add-host host.docker.internal:host-gateway \
        --network oha-network \
        --name "${CONTAINER_NAME}" \
        docker.all-hands.dev/all-hands-ai/openhands:0.46.0 \
        python3 -m openhands.cli.main --override-cli-mode true
else
    echo "Error: .env file not found"
    exit 1
fi
