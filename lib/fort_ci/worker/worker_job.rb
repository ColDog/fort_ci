require "json"
require "sequel"

module FortCI
  module Worker
    class WorkerJob < Sequel::Model
      def set_error(e)
        self.last_error = "#{e.message}\n\n#{e.backtrace.join("\n")}"
        save
      end
    end
  end
end
