require "fort_ci/config"
require "sequel"

module FortCI
  DB = Sequel.connect(FortCI.config.database)
end
