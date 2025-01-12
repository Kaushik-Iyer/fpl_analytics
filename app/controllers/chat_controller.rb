class ChatController < ApplicationController
    protect_from_forgery with: :null_session
  
    def respond
      session[:chat_history] ||= []
      user_query = params[:query]
      response = ChatService.respond(user_query)
      render json: { response: response }
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end