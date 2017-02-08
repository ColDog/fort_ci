require "fort_ci/db"
require "fort_ci/models/event"
require "fort_ci/helpers/serialization_helper"
require "fort_ci/jobs/pipeline_stage_job"
require "sequel"

module FortCI
  class Pipeline < Sequel::Model
    include SerializationHelper

    plugin :serialization
    serialize_attributes :json, :event
    serialize_attributes :json, :variables
    one_to_many :jobs
    many_to_one :project

    def definition_class
      @definition_class ||= FortCI.pipeline_definitions[definition]
    end

    def variables
      @variables ||= symbolize_keys(super)
    end

    def event
      @event ||= Event.new(symbolize_keys(super))
    end

    def run
      PipelineStageJob.enqueue self
    end

    def after_create
      super
      run
    end

  end
end
