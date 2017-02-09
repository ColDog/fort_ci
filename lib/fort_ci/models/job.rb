require "fort_ci/db"
require "fort_ci/helpers/serialization_helper"
require "fort_ci/clients/runner_client"
require "sequel"

module FortCI
  class Job < Sequel::Model
    STATUSES = %w(QUEUED PROCESSING FAILED COMPLETED CANCELLED).freeze

    include SerializationHelper
    include RunnerClient

    unrestrict_primary_key
    plugin :serialization

    serialize_attributes :json, :spec
    many_to_one :pipeline
    many_to_one :project

    def self.pop(runner)
      where(status: 'QUEUED', runner: nil).limit(1).update(runner: runner, status: 'PROCESSING')
      find(runner: runner, status: 'PROCESSING')
    end

    def self.reject(runner, id)
      where(id: id, runner: runner).update(runner: nil, status: 'QUEUED')
    end

    def self.update_status(runner, id, status, output_url=nil)
      where(id: id, runner: runner).update(status: status.to_s.upcase, output_url: output_url)
    end

    def after_save
      super
      pipeline.run
    end

    def project
      super || pipeline.project
    end

    def spec
      @spec ||= symbolize_keys(super || {})
    end

    def cancel
      if runner
        cancel_runner
      end
    ensure
      update(status: 'CANCELLED')
    end

    def output
      if status == 'QUEUED'
        nil
      elsif output_url
        get_remote_output output_url
      else
        runner_output
      end
    end

  end
end
