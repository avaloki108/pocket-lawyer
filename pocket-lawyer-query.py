def generate_legal_response(self, query, state, relevant_docs):
    context = "\n".join([doc.content for doc in relevant_docs])
    sources = [doc.citation for doc in relevant_docs]
    
    prompt = f"""
    Based ONLY on the following legal text from {state}:
    
    {context}
    
    Answer this question: {query}
    
    Requirements:
    - Use ONLY information from the provided text
    - Cite specific statutes/cases (e.g., "According to [Citation]...")
    - If the provided text doesn't address the question, say so
    - Emphasize this is legal information, not advice
    """
