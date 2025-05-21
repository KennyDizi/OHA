# OHA

🌾 🥳 🌋 🏰 🌅 🌕 [OpenHands](https://github.com/All-Hands-AI/OpenHands) Advanced 🌖 🌔 🌈 🏆 👑

## SWE Bench Leaderboard

### All

[#1](https://multi-swe-bench.github.io/#/)

![SWE Bench Leaderboard showing MopenHands + Claude-3.7-Sonnet at #1 with 19.32% overall resolution rate](./assets/SWE-Bench.png)

*MopenHands + Claude-3.7-Sonnet achieves state-of-the-art performance on the SWE-bench leaderboard.*

### Python

![SWE Bench Python Leaderboard](./assets/SWE-Bench-Python.png)

### TypeScript

![SWE Bench TypeScript Leaderboard](./assets/SWE-Bench-TypeScript.png)

## Environment Setup

### Copy the example environment file

```bash
cp .env.example .env
```

### Configure your environment variables in `.env`

- `LLM_API_KEY`          : Your LLM provider API key **(required)**
- `LLM_PROVIDER`         : LLM provider to use (default: "Anthropic")
- `LLM_MODEL`            : Model to call (default: "anthropic/claude-3-7-sonnet-20250219")
- `LLM_NUM_RETRIES`      : How many times to retry a failed completion (default: 3)
- `LLM_CACHING_PROMPT`   : Enable prompt/result cache (default: true)
- `CORE_REASONING_EFFORT`: Agent reasoning effort, e.g. "low" / "medium" / "high" (default: "high")
- `CORE_PLATFORM`        : Target platform architecture (default: "linux/amd64")
- `AGENT_MEMORY_ENABLED` : Persist and recall agent memory across runs (default: true)
- `CONTAINER_NAME`       : Name given to the Docker container (default: "OHA")
- `AGENT_ENABLE_THINK`   : Emit the agent's internal THINK steps to the logs (default: true)
- `AGENT_ENABLE_MCP`     : Enable multi-component-planning mode (default: false)

Read more at [here](https://docs.all-hands.dev/modules/usage/llms)

## Running the Application

### Make the run script executable

```bash
chmod +x run-open-hands.sh
```

### Run the application

```bash
./run-open-hands.sh
```

The script will:

- Load environment variables from `.env`
- Set up the workspace directory
- Run the Open Hands container with the necessary configurations
- Mount required volumes for workspace and Docker socket
- Connect to the specified LLM provider

## Requirements

- Docker installed and running
- Valid LLM Provider API key
- Proper permissions to access Docker socket

### Prompting Best Practices

Check it out [here](https://docs.all-hands.dev/modules/usage/prompting/prompting-best-practices) to learn how to prompt efficiently.

### Custom repository knowledge base

Create repository-specific Microagents to store the repository knowledge base. Check it out [here](https://docs.all-hands.dev/modules/usage/prompting/microagents-repo)

### Model Context Protocol

[MCP](https://github.com/All-Hands-AI/OpenHands/blob/main/docs/modules/usage/mcp.md)

### Reference docs

Put all development documents to folder `reference_docs` at root repository folder (Markdown format is recommended). Create `index.md` to brief the overview of all document files. You can create each `index.md` file for each sub-folder.
