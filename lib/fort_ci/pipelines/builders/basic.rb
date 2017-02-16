require "fort_ci/helpers/serialization_helper"
require "fort_ci/pipelines/definition"
require "fort_ci/pipelines/job_spec"
require "yaml"

module FortCI
  module Pipelines
    module Builders
      module Basic
        include FortCI::SerializationHelper

        def basic_job_from_file
          ci_file = project.owner.client.file(project.name, 'ci.yml')
          return nil unless ci_file

          build = symbolize_keys(YAML.load(ci_file))

          JobSpec.new do |spec|
            (build[:services] || {}).each do |id, service|
              spec.services[id] = ServiceSpec.new(service)
            end

            spec.build = BuildSpec.new(build[:build]) if build[:build]

            spec.repo do |repo|
              repo.project = project
              repo.commit = event.data[:commit]
              repo.branch = event.data[:branch]
              repo.pull_request = event.data[:pull_request]
            end

            cmds = build[:commands] || {}
            spec.command_section :setup,      run_on_failure: false, run_on_success: true, commands: (cmds[:setup] || [])
            spec.command_section :test,       run_on_failure: false, run_on_success: true, commands: (cmds[:test] || [])
            spec.command_section :on_success, run_on_failure: false, run_on_success: true, commands: (cmds[:on_success] || [])
            spec.command_section :on_failure, run_on_failure: true, run_on_success: false, commands: (cmds[:on_failure] || [])
          end
        end

      end
    end
  end
end
