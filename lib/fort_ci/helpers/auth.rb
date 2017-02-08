require "fort_ci/helpers/serialization"
require "jwt"

module FortCI
  module Helpers
    module Auth
      include Serialization

      def current_user
        @current_user ||= FortCI::User.find(id: session[:user_id])    if session[:user_id]
        @current_user ||= FortCI::User.find(id: auth_token[:user_id]) if auth_token[:user_id]
        @current_user
      end

      def protected!
        unless current_user
          render json: {error: 'Unauthorized', status: 401}, status: 401
        end
      end

      def auth_token
        @auth_token = begin
          token = env['HTTP_AUTHORIZATION'] ? env['HTTP_AUTHORIZATION'].split(' ')[1] : nil
          if token
            payload = JWT.decode(token, Config.secret, true, algorithm: 'HS256').try(:[], 0)
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
end
