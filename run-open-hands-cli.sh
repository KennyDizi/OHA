#!/bin/bash

# Check if .env file exists
if [ -f .env ]; then
    # Load environment variables from .env file
    export $(cat .env | grep -v '^#' | xargs)

    # ---------- guarantee a deterministic container name ----------
    : "${CONTAINER_NAME:=oha-container}"   # default if .env omits it
    # ----------------------------------------------------------------

    # Only pass CORE_REASONING_EFFORT to Docker if it is set/non-empty
    CORE_REASONING_EFFORT_ARG=""
    if [[ -n "$CORE_REASONING_EFFORT" ]]; then
        CORE_REASONING_EFFORT_ARG="-e CORE_REASONING_EFFORT=${CORE_REASONING_EFFORT}"
    fi

    # Display selected model & reasoning-effort (only when an effort was supplied)
    if [[ -n "$CORE_REASONING_EFFORT_ARG" ]]; then
        echo "Using model: ${LLM_MODEL} with reasoning effort: ${CORE_REASONING_EFFORT}"
    fi

    export SANDBOX_VOLUMES=$(pwd):/workspace:rw
    export RUNTIME_MOUNT=$(pwd):/workspace:rw

    openhands
else
    echo "Error: .env file not found"
    exit 1
fi
