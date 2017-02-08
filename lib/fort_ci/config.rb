require "fort_ci/helpers"
require "logger"
require "yaml"

module FortCI
  class Config
    include Helpers
    attr_accessor :ui_root_url, :api_root_url, :env, :secret, :github_credentials, :log_sql

    def initialize
      @ui_root_url = ENV['UI_ROOT'] || 'http://localhost:3001'
      @api_root_url = ENV['API_ROOT'] || 'http://localhost:3000/api'
      @database = symbolize_keys(load_config_file('./database.yml'))
      @env = (ENV['RAILS_ENV'] || ENV['RACK_ENV'] || ENV['ENV'] || 'development').to_sym
      @secret = ENV['SECRET_KEY_BASE'] || 'secret'
      
      @github_credentials = {
        key: ENV['GITHUB_KEY'],
        secret: ENV['GITHUB_SECRET'],
        scope: %W( read:org repo user public_repo )
      }
    end

    def database
      if log_sql
        (@database[env] || {}).merge(logger: logger)
      else
        @database[env] || {}
      end
    end
  end

  class << self
    attr_writer :config, :logger
    def config
      @config ||= Config.new
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
