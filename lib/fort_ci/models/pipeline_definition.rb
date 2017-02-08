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
  end
end
