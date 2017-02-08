module FortCI
  class PipelineDefinition
    attr_accessor :pipeline, :event

    def initialize(pipeline, event)
      @pipeline = pipeline
      @event = event
    end

    def self.triggered_by?(event)
      true
    end

    def self.stages(*stages)
      @stages ||= stages
    end

    def self.ensure_stages(*stages)
      @ensure_stages ||= stages
    end

  end
end
