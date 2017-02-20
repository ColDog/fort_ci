require "fort_ci/version"
require "fort_ci/config"
require "fort_ci/db"
require "fort_ci/models"
require "fort_ci/worker"
require "fort_ci/app"
require "fort_ci/pipelines"

module FortCI
  def self.run_single(port: 3001, bind: '0.0.0.0')
    Thread.new do
      Worker.executor.run
    end
    Rack::Handler.default.run FortCI::App.new, Port: port, Bind: bind
  end
end
