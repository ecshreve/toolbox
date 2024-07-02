import uuid
import os
import streamlit as st
from dotenv import load_dotenv
from consts import DOT_BOT_PROMPT

from langchain.agents import Tool
from langchain.utilities.google_serper import GoogleSerperAPIWrapper
from langchain_community.callbacks import StreamlitCallbackHandler
from langchain_community.chat_message_histories.streamlit import StreamlitChatMessageHistory
from langchain_community.tools.wikipedia.tool import WikipediaQueryRun
from langchain_community.tools.tavily_search import TavilySearchResults
from langchain_community.utilities.wikipedia import WikipediaAPIWrapper
from langchain_core.runnables import RunnableConfig
from langchain_openai import ChatOpenAI, OpenAIEmbeddings
from langchain_pinecone import PineconeVectorStore
from langchain.agents import create_react_agent, AgentExecutor
from langchain.memory import ConversationBufferMemory
from langchain.tools.retriever import create_retriever_tool

# Load environment variables
load_dotenv()
st.set_page_config(page_title="Toolbox Chat", page_icon="🪛")
st.sidebar.header("Toolbox Chat")
st.title("🪛 Toolbox Chat")

required_env_vars = [
    "LANGCHAIN_ENDPOINT", "LANGCHAIN_API_KEY", "LANGCHAIN_PROJECT", "LANGCHAIN_TRACING_V2",
    "TAVILY_API_KEY", "OPENAI_API_KEY", "PINECONE_API_KEY", "TOOLBOX_DIR", "SERPER_API_KEY",
]

# Collect environment variables and check if they are all set.
vals = {var: os.getenv(var) for var in required_env_vars}
valid = all(v is not None for v in vals.values())

with st.sidebar:
    status_text = ":green[Environment is valid]" if valid else ":red[Environment is invalid]"
    with st.expander(status_text, expanded=False):
        on = st.toggle("Show values")
        for var in required_env_vars:
            stat_out = "✅" if vals[var] is not None else "❌"
            st.write(f"{stat_out} {var}")
            if on:
                st.code(f"{vals[var]}")

uploaded_file = st.file_uploader(
    "Upload a pdf, docx, or txt file",
    type=["pdf", "docx", "txt"],
    help="Scanned documents are not supported yet!",
)

# Initialize conversation history and memory
msgs = StreamlitChatMessageHistory()
memory = ConversationBufferMemory(
    chat_memory=msgs, return_messages=True, memory_key="chat_history", output_key="output"
)
# Reset chat history if button is clicked
if len(msgs.messages) == 0 or st.sidebar.button("Reset chat history"):
    msgs.clear()
    msgs.add_ai_message("How can I help you?")
    st.session_state.steps = {}

# Display conversation messages
avatars = {"human": "user", "ai": "assistant"}
for idx, msg in enumerate(msgs.messages):
    with st.chat_message(avatars[msg.type]):
        for step in st.session_state.steps.get(str(idx), []):
            if step[0].tool == "_Exception":
                continue
            with st.status(f"**{step[0].tool}**: {step[0].tool_input}", state="complete"):
                st.write(step[0].log)
                st.write(step[1])
        st.write(msg.content)

# Initialize tools for agent
search_tool = TavilySearchResults()
serper_wrapper = GoogleSerperAPIWrapper()
serper_tool = Tool(
        name="Intermediate Answer",
        func=serper_wrapper.run,
        description="useful for when you need to ask with search"
    )

api_wrapper = WikipediaAPIWrapper(wiki_client={}, top_k_results=1, doc_content_chars_max=100)
wikipedia_tool = WikipediaQueryRun(api_wrapper=api_wrapper)

embeddings = OpenAIEmbeddings(dimensions=3072, model="text-embedding-3-large")
vector = PineconeVectorStore(index_name="repo-index", embedding=embeddings)
retriever = vector.as_retriever()
retriever_tool = create_retriever_tool(
    retriever,
    "retriever_tool",
    "Search for information about Eric Shreve and information about Eric's \
    personal development environment and preferred system configuration. \
    Use this tool for any questions about the toolbox repository or Eric Shreve."
)

tools = [search_tool, retriever_tool, serper_tool, wikipedia_tool]
from langchain.output_parsers import ResponseSchema, StructuredOutputParser
from langchain_core.prompts import PromptTemplate
from langchain_openai import ChatOpenAI


# Process chat input and generate response
if prompt_str := st.chat_input(placeholder="Who won the Women's U.S. Open in 2018?"):
    st.chat_message("user").write(prompt_str)
    llm = ChatOpenAI(model="gpt-4o", streaming=True)
    prompt = DOT_BOT_PROMPT
    chat_agent = create_react_agent(llm=llm, prompt=prompt, tools=tools)
    executor = AgentExecutor.from_agent_and_tools(
        agent=chat_agent,  # type: ignore
        tools=tools,
        memory=memory,
        return_intermediate_steps=True,
        handle_parsing_errors=True,
        max_iterations=5,
        verbose=True,
    )

    import re
    # Display agent's response
    with st.chat_message("assistant"):
        st_cb = StreamlitCallbackHandler(st.container(), expand_new_thoughts=False)
        cfg = RunnableConfig(callbacks=[st_cb], metadata={"conversation_id": str(uuid.uuid4())})
        response = executor.invoke({"input": prompt_str}, cfg)
        match = re.search(r'===META===(.*?)===META===', response["output"], re.DOTALL)
        if match:
            extracted = match.group(1)
            clean = response["output"].replace(match.group(0), "")
            st.write(clean)
            st.sidebar.code(extracted)
        else:
            st.write(response["output"])
        st.session_state.steps[str(len(msgs.messages) - 1)] = response["intermediate_steps"]
