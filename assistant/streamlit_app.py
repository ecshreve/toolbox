import utils
import streamlit as st

from dotenv import load_dotenv

from langchain.agents import AgentType
from langchain_openai import ChatOpenAI
from langchain.tools.tavily_search import TavilySearchResults
from langchain.agents import initialize_agent, Tool
from langchain.callbacks import StreamlitCallbackHandler

st.set_page_config(page_title="ChatWeb", page_icon="🌐")
st.header('Chatbot with Internet Access')
st.write('Equipped with internet access, enables users to ask questions about recent events')
st.write('[![view source code ](https://img.shields.io/badge/view_source_code-gray?logo=github)](https://github.com/shashankdeshpande/langchain-chatbot/blob/master/pages/3_%F0%9F%8C%90_chatbot_with_internet_access.py)')

load_dotenv()

class ChatbotTools:

    def __init__(self):
        utils.configure_openai_api_key()
        self.openai_model = "gpt-3.5-turbo"

    def setup_agent(self):
        # Define tool
        search = TavilySearchResults()
        tools = [
            Tool(
                name="Tavily Search Results",
                func=search.run,
                description="Useful for when you need to answer questions about current events. You should ask targeted questions",
            )
        ]

        # Setup LLM and Agent
        llm = ChatOpenAI(name=self.openai_model, streaming=True)
        agent = initialize_agent(
            tools=tools,
            llm=llm,
            agent=AgentType.ZERO_SHOT_REACT_DESCRIPTION,
            handle_parsing_errors=True,
            verbose=True
        )
        return agent

    @utils.enable_chat_history
    def main(self):
        agent = self.setup_agent()
        user_query = st.chat_input(placeholder="Ask me anything!")
        if user_query:
            utils.display_msg(user_query, 'user')
            with st.chat_message("assistant"):
                st_cb = StreamlitCallbackHandler(st.container())
                response = agent.run(user_query, callbacks=[st_cb])
                st.session_state.messages.append({"role": "assistant", "content": response})
                st.write(response)

if __name__ == "__main__":
    obj = ChatbotTools()
    obj.main()

# import streamlit as st
# from langchain.llms import OpenAI

# st.title('🦜🔗 Quickstart App')

# openai_api_key = st.sidebar.text_input('OpenAI API Key', type='password')

# def generate_response(input_text):
#     llm = OpenAI(temperature=0.7, openai_api_key=openai_api_key)
#     st.info(llm(input_text))

# with st.form('my_form'):
#     text = st.text_area('Enter text:', 'What are the three key pieces of advice for learning how to code?')
#     submitted = st.form_submit_button('Submit')
#     if not openai_api_key.startswith('sk-'):
#         st.warning('Please enter your OpenAI API key!', icon='⚠')
#     if submitted and openai_api_key.startswith('sk-'):
#         generate_response(text)
