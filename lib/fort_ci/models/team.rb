require "fort_ci/db"
require "sequel"

module FortCI
  class Team < Sequel::Model
    many_to_one :users
  end
end
