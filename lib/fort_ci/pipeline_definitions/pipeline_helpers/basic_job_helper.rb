require "fort_ci/helpers/serialization_helper"

module FortCI
  module PipelineHelpers
    module BasicJobHelper
      include FortCI::SerializationHelper

      def basic_job_from_file
        ci_file = project.owner.client.file(project.name, 'ci.yml')
        return nil unless ci_file

        spec = {}
        build = symbolize_keys(YAML.load(ci_file))

        # services are copied directly
        spec[:services] = build[:services]
        spec[:build] = build[:build]

        # turns each key into a section
        spec[:commands] = []

        cmds = spec[:commands]

        cmds[:setup].each do |cmd|
          spec[:commands] << {
              id: :setup,
              cmd: cmd,
              target: :machine,
              run_on_failure: false,
              run_on_success: true,
          }
        end

        cmds[:test].each do |cmd|
          spec[:commands] << {
              id: :test,
              cmd: cmd,
              target: :build,
              run_on_failure: false,
              run_on_success: true,
          }
        end

        cmds[:on_success].each do |cmd|
          spec[:commands] << {
              id: :on_success,
              cmd: cmd,
              target: :machine,
              run_on_failure: false,
              run_on_success: true,
          }
        end

        cmds[:on_failure].each do |cmd|
          spec[:commands] << {
              id: :on_failure,
              cmd: cmd,
              target: :machine,
              run_on_failure: true,
              run_on_success: false,
          }
        end

        spec
      end

    end
  end
end
