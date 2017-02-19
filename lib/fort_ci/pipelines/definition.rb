require "fort_ci/pipelines/job_spec"

module FortCI
  module Pipelines
    class Definition
      attr_accessor :pipeline, :event

      def initialize(pipeline, event)
        @pipeline = pipeline
        @event = event
        @job_creation_idx = 1
      end

      def self.register(name=nil)
        FortCI.register_pipeline_definition(self, name || self.name)
      end

      def self.triggered_by?(event)
        true
      end

      def self.stages
        @stages ||= []
      end

      def self.ensure_stages
        @ensure_stages ||= []
      end

      def self.stage_opts
        @stage_opts ||= {}
      end

      def self.stage(name, opts={})
        stages << name
        stage_opts[name] = opts
      end

      def self.ensure_stage(name, opts={})
        ensure_stages << name
        stage_opts[name] = opts
      end

      def project
        pipeline.project
      end

      def stage
        pipeline.stage.to_sym
      end

      def create_job(spec)
        raise ArgumentError, "Spec must be a JobSpec" unless spec.is_a?(JobSpec)

        id = spec.id

        @job_creation_idx += 1
        id = "#{pipeline.definition}.#{pipeline.id}.#{stage}-#{@job_creation_idx}" unless id

        Job.create(
            id: id,
            project: spec.repo.project,
            pipeline: pipeline,
            pipeline_stage: stage,
            status: 'QUEUED',
            version: FortCI::VERSION,
            commit: spec.repo.commit,
            branch: spec.repo.branch,
            build: spec.build_spec,
            services: spec.services_spec,
            commands: spec.commands_spec,
        )
      end

    end
  end
end
