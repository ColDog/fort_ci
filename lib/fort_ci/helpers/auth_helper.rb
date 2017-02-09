require "fort_ci/helpers/serialization_helper"
require "jwt"

module FortCI
  module AuthHelper
    include SerializationHelper

    def add_entity_to_meta
      meta[:entity] = {
          type: current_entity.class.name.split("::")[-1],
          id: current_entity.id,
      }
    end

    def current_user
      @current_user ||= FortCI::User.find(id: session[:user_id])    if session[:user_id]
      @current_user ||= FortCI::User.find(id: auth_token[:user_id]) if auth_token[:user_id]
      @current_user
    end

    def current_entity
      @current_entity ||= begin
        if params[:team_id]
          current_user.find_team!(params[:team_id])
        else
          current_user
        end
      end
    end

    def current_runner
      @current_runner ||= auth_token[:runner] if auth_token
    end

    def protected!
      if current_user
        add_entity_to_meta
      else
        render json: {error: 'Unauthorized', status: 401}, status: 401
      end
    end

    def protected_runner!
      unless current_runner
        render json: {error: 'Unauthorized', status: 401}, status: 401
      end
    end

    def auth_token
      @auth_token = begin
        token = env['HTTP_AUTHORIZATION'] ? env['HTTP_AUTHORIZATION'].split(' ')[1] : nil
        if token
          payload, _ = JWT.decode(token, FortCI.config.secret, true, algorithm: 'HS256')
          symbolize_keys(payload) if payload
        else
          {}
        end
      rescue JWT::VerificationError
        {}
      end
    end

  end
end
