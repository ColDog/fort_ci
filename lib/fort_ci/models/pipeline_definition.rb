module FortCI
  class PipelineDefinition
    attr_accessor :pipeline, :event

    def initialize(pipeline, event)
      @pipeline = pipeline
      @event = event
      @job_creation_idx = 1
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

    def create_job(key: nil, project: nil, scm: nil, spec: nil)
      project = self.project unless project

      scm = {} if scm.nil?
      if project
        scm[:owner] = project.owner.username
        scm[:name] = project.name
        scm[:provider] = project.repo_provider
      end

      @job_creation_idx += 1
      key = "#{pipeline.definition}.#{pipeline.id}.#{stage}-#{@job_creation_idx}" unless key

      puts "creating job!!!"
      Job.create(
          pipeline: pipeline,
          pipeline_stage: stage,
          status: 'QUEUED',
          spec: spec.merge(repo: scm),
          commit: scm[:commit],
          branch: scm[:branch],
          id: key,
      )
    end

    def create_default_job(spec)
      scm = {}
      if event && event.data[:commit]
        scm[:commit] = event.data[:commit]
        scm[:branch] = event.data[:branch]
        scm[:pull_request] = event.data[:pull_request]
      else
        latest = project.owner.client.latest_commit(project.name)
        scm[:commit] = latest[:sha]
        scm[:branch] = latest[:branch]
      end

      create_job(
          project: project,
          scm: scm,
          spec: spec,
      )
    end

  end
end
