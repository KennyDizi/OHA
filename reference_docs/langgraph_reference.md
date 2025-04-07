# LangGraph Reference Guide

## Overview
LangGraph is a library built on top of LangChain for creating stateful, multi-actor applications using Large Language Models (LLMs). It provides a graph-based framework for orchestrating complex LLM workflows with multiple agents and state management.

## Core Concepts

### StateGraph
The primary class for defining the flow of a LangGraph application. It manages the state and transitions between different nodes in the graph.

```python
from langgraph.graph import StateGraph

# Define state class
class MyState:
    messages: list
    context: dict = {}
    
# Create a graph with the state
graph = StateGraph(MyState)
```

### Nodes
Functions that process the current state and return updates. Each node represents a step in the workflow.

```python
def process_node(state):
    # Process state
    # Return updates to state
    return {"key": "updated_value"}
```

### Edges
Connections between nodes that define the flow of execution.

```python
# Add a direct edge
graph.add_edge("node_a", "node_b")

# Add conditional edges
graph.add_conditional_edges(
    "node_a",
    condition_function,
    {
        "option1": "node_b",
        "option2": "node_c"
    }
)
```

### State Management
LangGraph maintains state throughout the execution of the graph, allowing for complex, stateful applications.

## Common Patterns

### Basic Conversational Agent
```python
from langgraph.graph import StateGraph, END
from langchain_core.messages import HumanMessage, AIMessage
from langchain_openai import ChatOpenAI

class AgentState:
    messages: list
    
llm = ChatOpenAI()

def generate_response(state):
    messages = state["messages"]
    response = llm.invoke(messages)
    return {"messages": messages + [response]}

def check_if_done(state):
    # Logic to determine if conversation should end
    if condition:
        return "end"
    return "continue"

workflow = StateGraph(AgentState)
workflow.add_node("generate", generate_response)
workflow.add_conditional_edges(
    "generate",
    check_if_done,
    {
        "continue": "generate",
        "end": END
    }
)
workflow.set_entry_point("generate")
app = workflow.compile()
```

### Multi-Agent System
```python
class MultiAgentState:
    messages: list
    current_agent: str = "router"
    
# Define specialized agents
router = ChatOpenAI().with_system_message("You route queries to specialists")
math_agent = ChatOpenAI().with_system_message("You solve math problems")
coding_agent = ChatOpenAI().with_system_message("You write code")

# Define routing logic
def route_query(state):
    # Determine which agent should handle the query
    return {"current_agent": "selected_agent"}

# Define agent nodes
def math_node(state):
    # Process with math agent
    return {"messages": updated_messages, "current_agent": "done"}

# Build graph with conditional routing
workflow = StateGraph(MultiAgentState)
workflow.add_node("router", route_query)
workflow.add_node("math", math_node)
# Add other nodes...

workflow.add_conditional_edges(
    "router",
    lambda state: state["current_agent"],
    {
        "math": "math",
        "coding": "coding",
        # Other routes...
    }
)
```

## Advanced Features

### Parallel Execution
LangGraph supports running multiple nodes in parallel:

```python
# Define a thread pool for parallel execution
from langgraph.graph import ThreadPoolExecutor
executor = ThreadPoolExecutor(max_workers=4)

# Use the executor when compiling
app = workflow.compile(executor=executor)
```

### Persistent State
LangGraph can persist state between runs:

```python
from langgraph.checkpoint import JsonCheckpoint

# Create a checkpoint
checkpoint = JsonCheckpoint(directory="./checkpoints")

# Compile with checkpoint
app = workflow.compile(checkpointer=checkpoint)

# Run with a specific checkpoint key
result = app.invoke({"input": "value"}, config={"configurable": {"checkpoint_key": "unique_id"}})
```

### Streaming
LangGraph supports streaming responses:

```python
# Stream the execution
for chunk in app.stream({"messages": [HumanMessage(content="Hello")]}):
    # Process each chunk
    print(chunk)
```

## Integration with LangChain

LangGraph works seamlessly with LangChain components:

- **LLM Models**: ChatOpenAI, Anthropic, etc.
- **Message Types**: HumanMessage, AIMessage, SystemMessage
- **Tools**: Can be integrated into nodes for external actions
- **Memory**: Can be incorporated into the state

## Best Practices

1. **State Design**: Keep state classes clean and focused
2. **Error Handling**: Add error handling nodes to manage failures
3. **Modularity**: Break complex workflows into smaller, reusable subgraphs
4. **Testing**: Test individual nodes before integrating them into the graph
5. **Monitoring**: Add logging to track the flow through the graph

## Version Information
- This reference is for LangGraph version 0.0.x (as of April 2024)
- Compatible with LangChain 0.1.x