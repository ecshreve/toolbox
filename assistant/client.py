import re
from tabnanny import verbose
from langchain.agents import ConversationalChatAgent, Agent, AgentExecutor, create_react_agent
from langchain.memory import ConversationBufferMemory
from langchain_community.callbacks import StreamlitCallbackHandler
from langchain_community.chat_message_histories import StreamlitChatMessageHistory
from langchain_community.tools.tavily_search import TavilySearchResults
from langchain_core.runnables import RunnableConfig
from langchain_openai import ChatOpenAI, OpenAIEmbeddings
from langchain_community.document_loaders.git import GitLoader
from langchain_community.tools import WikipediaQueryRun
from langchain_community.utilities import WikipediaAPIWrapper
from langchain.tools.retriever import create_retriever_tool
from langchain_pinecone import PineconeVectorStore
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain import hub
import uuid
import streamlit as st

import os
from dotenv import load_dotenv
load_dotenv()

required_env_vars = ["TOOLBOX_PATH",
                     "OPENAI_API_KEY",
                     "PINECONE_API_KEY",
                     "LANGCHAIN_TRACING_V2",
                     "LANGCHAIN_ENDPOINT",
                     "LANGCHAIN_API_KEY",
                     "LANGCHAIN_PROJECT",
                     "TAVILY_API_KEY",
                     "CHARM_HOST"
                     ]
vals = {var: os.getenv(var) for var in required_env_vars}
valid = all([v is not None for v in vals.values()])

st.set_page_config(page_title="Toolbox Chat", page_icon="🔨")
st.title("🔨🪛 Toolbox Chat")
with st.sidebar:
    status_text = ":green[Environment is valid]" if valid else ":red[Environment is invalid]"
    with st.expander(status_text, expanded=False):
        on = st.toggle("Show values")
        for var in required_env_vars:
            stat_out = "✅" if vals[var] is not None else "❌"
            st.write(f"{stat_out} {var}")
            if on:
                st.code(f"{vals[var]}")

msgs = StreamlitChatMessageHistory()
memory = ConversationBufferMemory(
    chat_memory=msgs, return_messages=True, memory_key="chat_history", output_key="output"
)
if len(msgs.messages) == 0 or st.sidebar.button("Reset chat history"):
    msgs.clear()
    msgs.add_ai_message("How can I help you?")
    st.session_state.steps = {}

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

search_tool = TavilySearchResults()

embeddings = OpenAIEmbeddings(dimensions=512, model="text-embedding-3-small")
vector = PineconeVectorStore(index_name="toolbox-index", embedding=embeddings)
retriever = vector.as_retriever()

retriever_tool = create_retriever_tool(
    retriever,
    "retriever_tool",
    "Search for information about system configuration and development environment setup. Use this tool for any questions about the toolbox repository."
)

api_wrapper = WikipediaAPIWrapper(top_k_results=1, doc_content_chars_max=100)
wikipedia_tool = WikipediaQueryRun(api_wrapper=api_wrapper)

tools = [search_tool, retriever_tool, wikipedia_tool]

if prompt_str := st.chat_input(placeholder="Who won the Women's U.S. Open in 2018?"):
    st.chat_message("user").write(prompt_str)

    llm = ChatOpenAI(model="gpt-4-turbo-preview", streaming=True)
    prompt = hub.pull("ecshreve/dotprompt")
    chat_agent = create_react_agent(llm=llm, prompt=prompt, tools=tools)
    # chat_agent = ConversationalChatAgent.from_llm_and_tools(llm=llm, tools=tools)
    executor = AgentExecutor.from_agent_and_tools(
        agent=chat_agent,
        tools=tools,
        memory=memory,
        return_intermediate_steps=True,
        handle_parsing_errors=True,
        max_iterations=5,
        verbose=True,
    )

    with st.chat_message("assistant"):
        st_cb = StreamlitCallbackHandler(st.container(), expand_new_thoughts=False)
        cfg = RunnableConfig()
        cfg["callbacks"] = [st_cb]
        cfg["metadata"] = {"conversation_id": str(uuid.uuid4())}
        response = executor.invoke({"input": prompt_str}, cfg)
        st.write(response["output"])
        st.session_state.steps[str(len(msgs.messages) - 1)] = response["intermediate_steps"]