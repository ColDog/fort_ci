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

            if build[:build]
              spec.build = BuildSpec.new(build[:build])
            else
              spec.build do |build_spec|
                build_spec.id = 'app'
                build_spec.dockerfile = '.'
              end
            end

            spec.repo do |repo|
              repo.project = project

              if event.data[:commit]
                repo.commit = event.data[:commit]
                repo.branch = event.data[:branch]
              else
                latest_commit = project.owner.client.latest_commit(project.name)
                repo.commit = latest_commit[:sha]
                repo.branch = latest_commit[:branch]
              end

              repo.pull_request = event.data[:pull_request]
            end

            cmds = build[:commands] || {}
            spec.command_section :setup,      target: :machine, run_on_failure: false, run_on_success: true,  commands: (cmds[:setup] || [])
            spec.command_section :test,       target: :build,   run_on_failure: false, run_on_success: true,  commands: (cmds[:test] || [])
            spec.command_section :on_success, target: :machine, run_on_failure: false, run_on_success: true,  commands: (cmds[:on_success] || [])
            spec.command_section :on_failure, target: :machine, run_on_failure: true,  run_on_success: false, commands: (cmds[:on_failure] || [])
          end
        end

      end
    end
  end
end
