require "fort_ci/worker/worker_job"
require "fort_ci/worker/executor"

module FortCI
  module Worker
    class << self
      attr_writer :executor
      def executor
        @executor ||= Executor.new
      end
    end
  end
end