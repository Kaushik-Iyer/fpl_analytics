# config/initializers/gemini.rb
require 'dotenv/load'
module GeminiClient
    CHAT_CLIENT = Gemini.new(
      credentials: {
        service: 'generative-language-api',
        api_key: ENV['GEMINI_API_KEY']
      },
      options: { 
        model: 'gemini-1.5-flash',
        server_sent_events: true 
      }
    )
  
    EMBEDDING_CLIENT = Gemini.new(
      credentials: {
        service: 'generative-language-api',
        api_key: ENV['GEMINI_API_KEY']
      },
      options: { 
        model: 'text-embedding-004',
        server_sent_events: true
      }
    )
  end
  