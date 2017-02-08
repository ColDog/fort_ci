require "fort_ci/db"
require "sequel"

module FortCI
  class Job < Sequel::Model
    many_to_one :pipeline

    def project
      pipeline.project
    end

    

  end
end
