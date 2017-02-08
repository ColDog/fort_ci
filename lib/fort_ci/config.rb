require "yaml"
require "fort_ci/helpers"

module FortCI
  class Config
    include Helpers
    attr_accessor :ui_root_url, :api_root_url, :env, :secret

    def initialize
      @ui_root_url = ENV['UI_ROOT'] || 'http://localhost:3001'
      @api_root_url = ENV['API_ROOT'] || 'http://localhost:3000/api'
      @database = symbolize_keys(load_config_file('./database.yml'))
      @env = (ENV['RAILS_ENV'] || ENV['RACK_ENV'] || ENV['ENV'] || 'development').to_sym
      @secret = ENV['SECRET_KEY_BASE'] || 'secret'
    end

    def database
      @database[env]
    end
  end
end
