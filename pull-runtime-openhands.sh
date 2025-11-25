#!/bin/bash

podman pull docker.openhands.dev/openhands/runtime:0.62.0-nikolaik
podman tag docker.openhands.dev/openhands/runtime:0.62.0-nikolaik openhands/runtime:latest
