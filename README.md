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

- `LLM_PROVIDER`: Set to `Anthropic` (default)
- `LLM_API_KEY`: Your Anthropic API key
- `LLM_MODEL`: Set to `anthropic/claude-3-7-sonnet-20250219` (default)
- `APP_NAME`: Set to `openhands-app-advanced` (default)
- `AGENT_MEMORY_ENABLED`: Set to `true` to enable agent memory (default)

Read more at [here](https://docs.all-hands.dev/modules/usage/llms)

## Running the Application

1. Make the run script executable:

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
- Valid Anthropic API key
- Proper permissions to access Docker socket

### Prompting Best Practices

Check it out [here](https://docs.all-hands.dev/modules/usage/prompting/prompting-best-practices) to learn how to prompt efficiently.

### Custom repository knowledge base

Create repository-specific Microagents to store the repository knowledge base. Check it out [here](https://docs.all-hands.dev/modules/usage/prompting/microagents-repo)
