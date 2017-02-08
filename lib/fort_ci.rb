require "fort_ci/version"
require "fort_ci/config"

module FortCI
  class << self
    attr_writer :config
    def config
      @config ||= Config.new
    end
  end
end
