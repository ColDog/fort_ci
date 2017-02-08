require "fort_ci/db"
require "fort_ci/helpers/serialization_helper"
require "fort_ci/clients/runner_client"
require "sequel"

module FortCI
  class Job < Sequel::Model
    include SerializationHelper
    include RunnerClient
    plugin :serialization

    serialize_attributes :json, :spec
    many_to_one :pipeline

    def after_save
      super
      pipeline.run
    end

    def project
      pipeline.project
    end

    def spec
      @spec ||= symbolize_keys(super || {})
    end

  end
end
