require "fort_ci/db"
require "fort_ci/helpers/serialization_helper"
require "fort_ci/clients/runner_client"
require "sequel"

module FortCI
  class Job < Sequel::Model
    STATUSES = %w(QUEUED PROCESSING FAILED COMPLETED CANCELLED).freeze

    include SerializationHelper
    include RunnerClient
    plugin :serialization

    serialize_attributes :json, :spec
    many_to_one :pipeline

    def self.pop(runner)
      where(status: 'QUEUED', runner: nil).limit(1).update(runner: runner, status: 'PROCESSING').first
    end

    def self.reject(runner, id)
      where(key: id, runner: runner).update(runner: nil, status: 'QUEUED')
    end

    def self.update_status(runner, id, status)
      where(key: id, runner: runner).update(status: status.to_s.upcase)
    end

    def after_save
      super
      pipeline.run
    end

    def project
      pipeline.project
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
      elsif status == 'PROCESSING'
        runner_output
      else
        # todo: look in permanent storage
      end
    end

  end
end
