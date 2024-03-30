import os
import streamlit as st
from langchain_openai import OpenAI

from dotenv import load_dotenv
load_dotenv()


st.title("🦜🔗 Langchain Quickstart App")

with st.sidebar:
    st.info('''Remember to set OPENAI_API_KEY
            and/or other environment vars.
            ''')

    # Check LANGCHAIN vars here too?
    if not os.getenv("OPENAI_API_KEY"):
        st.error("Environment variable are not set correctly.")
    else:
        st.success("Environment variable are set correctly.")  

def generate_response(input_text):
    llm = OpenAI(temperature=0.7)
    st.info(llm(input_text))


with st.form("my_form"):
    text = st.text_area("Enter text:", "What are 3 key advice for learning how to code?")
    submitted = st.form_submit_button("Submit")
    if submitted:
        generate_response(text)