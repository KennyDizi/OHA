# LangGraph Cheat Sheet

## Installation
```bash
pip install langgraph langchain-core langchain-openai
```

## Basic Graph Creation

```python
from langgraph.graph import StateGraph, END

# Define state
class MyState:
    messages: list
    context: dict = {}

# Create graph
graph = StateGraph(MyState)

# Add nodes
graph.add_node("node_name", node_function)

# Add edges
graph.add_edge("node_a", "node_b")
graph.add_edge("final_node", END)  # END is a special constant

# Add conditional edges
graph.add_conditional_edges(
    "source_node",
    routing_function,  # Function that returns a string key
    {
        "key1": "destination_node1",
        "key2": "destination_node2"
    }
)

# Set entry point
graph.set_entry_point("starting_node")

# Compile
app = graph.compile()

# Run
result = app.invoke({"initial": "state"})
```

## Node Functions

```python
def node_function(state):
    # Process state
    # ...
    
    # Return updates to state (only changed fields)
    return {
        "field_to_update": new_value
    }
```

## Conditional Routing

```python
def route(state):
    # Logic to determine next step
    if condition:
        return "route_a"
    else:
        return "route_b"

graph.add_conditional_edges(
    "decision_node",
    route,
    {
        "route_a": "node_a",
        "route_b": "node_b"
    }
)
```

## Working with LLMs

```python
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, AIMessage, SystemMessage

# Create LLM
llm = ChatOpenAI(model="gpt-3.5-turbo")

# Use in node
def generate_response(state):
    messages = state["messages"]
    response = llm.invoke(messages)
    return {"messages": messages + [response]}
```

## Advanced Features

### Streaming
```python
for chunk in app.stream({"messages": [HumanMessage(content="Hello")]}):
    print(chunk)
```

### Parallel Execution
```python
from langgraph.graph import ThreadPoolExecutor

executor = ThreadPoolExecutor(max_workers=4)
app = workflow.compile(executor=executor)
```

### Checkpointing
```python
from langgraph.checkpoint import JsonCheckpoint

checkpoint = JsonCheckpoint(directory="./checkpoints")
app = workflow.compile(checkpointer=checkpoint)
```

## Common Patterns

### Basic Agent Loop
```python
# Create nodes
def generate(state): 
    # Generate response
    return {"messages": updated_messages}

def should_continue(state):
    # Check if we should continue
    if done_condition:
        return "end"
    return "continue"

# Build graph
workflow = StateGraph(AgentState)
workflow.add_node("generate", generate)
workflow.add_conditional_edges(
    "generate",
    should_continue,
    {
        "continue": "generate",
        "end": END
    }
)
```

### Multi-Agent System
```python
# Define routing
def route_to_agent(state):
    # Determine which agent to use
    return {"current_agent": selected_agent}

# Define agent handlers
def agent_a_handler(state):
    # Process with agent A
    return {"messages": updated_messages}

# Build graph with routing
workflow.add_node("router", route_to_agent)
workflow.add_node("agent_a", agent_a_handler)
workflow.add_node("agent_b", agent_b_handler)

workflow.add_conditional_edges(
    "router",
    lambda state: state["current_agent"],
    {
        "agent_a": "agent_a",
        "agent_b": "agent_b"
    }
)
```