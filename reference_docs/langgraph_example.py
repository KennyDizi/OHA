"""
LangGraph Example: Simple Question-Answering Agent with Research Capability

This example demonstrates a multi-step agent that can:
1. Analyze a question
2. Decide whether to research or answer directly
3. Perform research if needed
4. Formulate a final answer

Requirements:
- pip install langgraph langchain-openai
"""

from langgraph.graph import StateGraph, END
from langchain_core.messages import HumanMessage, AIMessage, SystemMessage
from langchain_openai import ChatOpenAI
import json

# Define our state
class AgentState:
    """State for the research agent workflow."""
    messages: list  # Conversation history
    question: str = ""  # The current question
    research_needed: bool = False  # Whether research is needed
    research_results: str = ""  # Results of any research performed
    
# Initialize the LLM
llm = ChatOpenAI(model="gpt-3.5-turbo")

# Define the nodes in our graph
def analyze_question(state):
    """Analyze the question and determine if research is needed."""
    messages = state["messages"]
    question = messages[-1].content
    
    system_prompt = """
    Analyze the following question and determine if external research is needed.
    Respond with a JSON object with the following structure:
    {"research_needed": true/false, "reasoning": "your reasoning here"}
    """
    
    analysis = llm.invoke([
        SystemMessage(content=system_prompt),
        HumanMessage(content=question)
    ])
    
    try:
        result = json.loads(analysis.content)
        return {
            "question": question,
            "research_needed": result.get("research_needed", False)
        }
    except:
        # Fallback if JSON parsing fails
        return {
            "question": question,
            "research_needed": "research" in question.lower()
        }

def perform_research(state):
    """Simulate performing research on the question."""
    question = state["question"]
    
    # In a real application, this would call a search API or other research tool
    research_prompt = f"""
    Simulate performing research on the following question:
    {question}
    
    Provide 3-5 key facts that would be helpful in answering this question.
    """
    
    research_results = llm.invoke([
        SystemMessage(content=research_prompt)
    ])
    
    return {"research_results": research_results.content}

def generate_answer(state):
    """Generate a final answer based on the question and any research."""
    messages = state["messages"]
    question = state["question"]
    research_results = state.get("research_results", "")
    
    if research_results:
        prompt = f"""
        Answer the following question:
        {question}
        
        Use these research findings to inform your answer:
        {research_results}
        """
    else:
        prompt = f"""
        Answer the following question to the best of your ability:
        {question}
        """
    
    answer = llm.invoke([
        SystemMessage(content=prompt)
    ])
    
    return {"messages": messages + [AIMessage(content=answer.content)]}

def route_based_on_research_need(state):
    """Determine the next step based on whether research is needed."""
    if state["research_needed"]:
        return "research"
    else:
        return "answer"

# Build the graph
workflow = StateGraph(AgentState)

# Add nodes
workflow.add_node("analyze", analyze_question)
workflow.add_node("research", perform_research)
workflow.add_node("answer", generate_answer)

# Add conditional edges
workflow.add_conditional_edges(
    "analyze",
    route_based_on_research_need,
    {
        "research": "research",
        "answer": "answer"
    }
)

# Add direct edge
workflow.add_edge("research", "answer")

# Add edge to END
workflow.add_edge("answer", END)

# Set the entry point
workflow.set_entry_point("analyze")

# Compile the graph
app = workflow.compile()

# Example usage
if __name__ == "__main__":
    # Example 1: Question that likely needs research
    result1 = app.invoke({
        "messages": [
            HumanMessage(content="What are the latest developments in quantum computing as of 2024?")
        ]
    })
    
    print("\n=== Example 1: Question requiring research ===")
    print(f"Q: {result1['messages'][0].content}")
    print(f"A: {result1['messages'][1].content}")
    
    # Example 2: Question that likely doesn't need research
    result2 = app.invoke({
        "messages": [
            HumanMessage(content="What is 15 multiplied by 27?")
        ]
    })
    
    print("\n=== Example 2: Question not requiring research ===")
    print(f"Q: {result2['messages'][0].content}")
    print(f"A: {result2['messages'][1].content}")