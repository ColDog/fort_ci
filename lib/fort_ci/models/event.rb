module FortCI
  class Event
    attr_accessor :name, :project, :data

    def initialize(data={})
      @data = data
      @name = data[:name]
      @project = data[:project_id] ? Project.find(id: data[:project_id]) : nil
    end

    def execute
      if project && project.enabled_pipelines
        pipeline_definitions = project.pipeline_definitions.map { |name| FortCI.pipeline_definitions[name] }.compact
      else
        pipeline_definitions = FortCI.pipeline_definitions.values
      end

      pipeline_definitions.each do |pipeline_def|
        if pipeline_def.triggered_by?(self)
          Pipeline.create(
              project: project,
              definition: pipeline_def.name,
              stage: nil,
              status: 'PENDING',
              event: data,
          )
        end
      end
    end

    def serializable_hash
      data
    end
  end
end
