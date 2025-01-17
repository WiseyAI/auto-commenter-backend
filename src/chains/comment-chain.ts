import { ChatOpenAI } from "@langchain/openai";
import { PromptTemplate } from "@langchain/core/prompts";
import { LLMChain } from "langchain/chains";

export const createCommentChain = () => {
    const llm = new ChatOpenAI({
        modelName: "gpt-3.5-turbo",
        temperature: 0.7,
    });

    const promptTemplate = PromptTemplate.fromTemplate(`
    Analyze this LinkedIn post and generate an engaging, professional comment.
    
    Post Content: {postContent}
    
    Guidelines for the comment:
    - Keep it professional and insightful
    - 2-3 sentences maximum
    - Reference specific points from the post
    - Add value to the discussion
    
    Comment:
  `);

    return new LLMChain({
        llm,
        prompt: promptTemplate,
    });
};
