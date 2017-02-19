require "json"
require "timeout"
require "fort_ci/worker/worker_job"
require "fort_ci/helpers/serialization_helper"

module FortCI
  module Worker
    class Executor
      include FortCI::SerializationHelper
      attr_accessor :id, :jobs_per_run, :max_attempts, :poll_interval, :job_timeout, :logging_enabled

      def initialize(queue_name: nil)
        @jobs_per_run = 10
        name = `hostname`.chomp("\n")
        @id = "#{name}.#{Process.pid}.#{rand(0..10000)}-#{queue_name || 'all'}"
        @max_attempts = 25
        @poll_interval = 5
        @job_timeout = 60
        @queue_name = queue_name || 'default'
        @logging_enabled = FortCI.config.env != :test
      end

      def enqueue(data: nil, job_class: nil, run_at: Time.now, queue: nil, priority: nil)
        data = serialize(data)
        priority = priority || 0
        queue = queue || 'default'

        WorkerJob.create(
            job_class: job_class,
            handler: data,
            priority: priority,
            queue: queue,
            run_at: run_at,
            attempts: 0,
            locked_at: nil,
        )
      end

      def unlock
        WorkerJob.where(locked_by: id).update(locked_by: nil)
      end

      def dequeue
        WorkerJob.limit(jobs_per_run)
            .where('`run_at` <= ?', Time.now)
            .where('`locked_by` IS NULL')
            .reverse_order(:priority)
            .update(locked_by: id, locked_at: Time.now)
        WorkerJob.where(locked_by: id)
      end

      def serialize(data)
        JSON.generate(data)
      end

      def deserialize(string)
        symbolize_keys JSON.parse(string)
      end

      def logger
        FortCI.logger
      end

      def run_all_queued
        run(WorkerJob.count)
      end

      def run(number_to_run=nil)
        logger.info("Starting worker... count=#{number_to_run} id=#{id}") if @logging_enabled

        begin
          while true
            t1 = Time.now
            failures = 0
            successes = 0

            dequeue.each do |job|
              if number_to_run
                number_to_run -= 1
              end

              if run_job(job)
                successes += 1
              else
                failures += 1
              end
            end

            t2 = Time.now

            if failures + successes > 0
              logger.info("Performed #{failures + successes} jobs in #{t2 - t1} seconds") if @logging_enabled
            end

            return if number_to_run && number_to_run <= 0
            sleep(poll_interval)
          end
        rescue Exception => e
          logger.warn("Exiting due to #{e}") if @logging_enabled
          return
        ensure
          logger.info("Unlocking") if @logging_enabled
          unlock
        end

      end

      def run_job(job)
        logger.info("Performing #{job.job_class}.#{job.id} attempts=#{job.attempts} priority=#{job.priority} run_at=#{job.run_at}") if @logging_enabled

        handler = nil
        begin
          handler = eval(job.job_class).new(deserialize(job.handler))

          Timeout::timeout(job_timeout) do
            handler.before if handler.respond_to?(:before)
            handler.perform
            handler.on_success if handler.respond_to?(:on_success)
          end

          job.destroy
          logger.info("Successful #{job.job_class}.#{job.id}") if @logging_enabled
          return true

        rescue Exception => e
          handler.on_failure if handler && handler.respond_to?(:on_failure)

          logger.info("Failed #{job.job_class}.#{job.id} err: #{e.message}") if @logging_enabled
          # puts e.backtrace

          if job.attempts + 1 > max_attempts
            logger.info("Failed #{job.job_class}.#{job.id} Reached max attempts") if @logging_enabled
            job.destroy
          else
            job.set_error(e)
          end

          job.update(locked_by: nil, attempts: job.attempts + 1)
          return false
        end
      end

    end
  end
end
