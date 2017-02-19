require "fort_ci/models"

module FortCI
  module Pipelines

    def self.define
      JobSpec.new { |spec| yield(spec) if block_given? }
    end

    class JobInvalid < RuntimeError
    end

    class JobSpec
      attr_accessor :id, :repo, :build, :services, :commands

      def initialize
        @id = nil
        @repo = nil
        @build = nil
        @services = {}
        @commands = []
        yield(self) if block_given?
      end

      def command
        cmd = CommandSpec.new
        @commands << cmd
        yield(cmd) if block_given?
        cmd
      end

      def command_section(id, run_on_failure: false, run_on_success: true, commands: [])
        yield(commands) if block_given?
        commands.each do |cmd|
          @commands << CommandSpec.new(id: id, run_on_success: run_on_success, run_on_failure: run_on_failure, cmd: cmd)
        end
      end

      def service(id)
        srvc = ServiceSpec.new
        @services[id] = srvc
        yield(srvc) if block_given?
        srvc
      end

      def build
        @build = BuildSpec.new unless @build
        yield(@build) if block_given?
        @build
      end

      def repo
        @repo = RepoSpec.new unless @repo
        yield(@repo) if block_given?
        @repo
      end

      def build_spec
        @build ? @build.spec : nil
      end

      def services_spec
        @services.reduce({}) { |h, (id, srvc)| h.merge(id => srvc.spec) }
      end

      def commands_spec
        @commands.map { |cmd| cmd.spec }
      end
    end

    class CommandSpec
      attr_accessor :id, :cmd, :target, :run_on_failure, :run_on_success
      def initialize(opts={})
        opts = {} unless opts
        @id = opts[:id]
        @cmd = opts[:cmd]
        @target = opts[:target]
        @run_on_failure = opts[:run_on_failure]
        @run_on_success = opts[:run_on_success]
      end

      def spec
        {id: id, cmd: cmd, run_on_failure: run_on_failure, run_on_success: run_on_success}
      end
    end

    class RepoSpec
      attr_accessor :project, :commit, :branch, :pull_request
      def initialize(opts={})
        opts = {} unless opts
        self.project = opts[:project] if opts[:project]
        @commit = opts[:commit]
        @branch = opts[:branch]
        @pull_request = opts[:pull_request]
      end

      def project=(val)
        if val.is_a?(FortCI::Project)
          @project = val
        else
          @project = FortCI::Project.with_pk!(val)
        end
      end

      def commit=(val)
        @commit = val.to_s
      end

      def branch=(val)
        @branch = val.to_s
      end

      def pull_request=(val)
        raise ArgumentError, "Pull Request must be a Bool" unless [true, false, nil].include?(val)
        @pull_request = val
      end
    end

    class ContainerSpec
      attr_accessor :id, :image, :cmd, :entrypoint, :env, :after
      def initialize(opts={})
        opts = {} unless opts
        self.id = opts[:id]
        self.image = opts[:image]
        self.cmd = opts[:cmd]
        self.entrypoint = opts[:entrypoint]
        self.env = opts[:env]
        self.after = opts[:after]
      end

      def id=(val)
        @id = val.to_s
      end

      def image=(val)
        @image = val.to_s
      end

      def cmd=(val)
        @cmd = val.to_s
      end

      def entrypoint=(val)
        @entrypoint = val.to_s
      end

      def env=(val)
        val = val.map { |k, v| "#{k}=#{v}" } if val.is_a?(Hash)
        raise ArgumentError, "Env must be a string array" unless val.nil? || val.all? { |v| v.is_a?(String) }
        @env = val
      end

      def after=(val)
        raise ArgumentError, "After must be a String array" unless val.nil? || val.all? { |v| v.is_a?(String) }
        @after = val
      end

      def spec
        {id: id, image: image, cmd: cmd, entrypoint: entrypoint, env: env, after: after}
      end
    end

    class ServiceSpec < ContainerSpec
    end

    class BuildSpec < ContainerSpec
      attr_accessor :dockerfile, :build_timeout
      def initialize(opts={})
        opts = {} unless opts
        @dockerfile = opts[:dockerfile]
        @build_timeout = opts[:build_timeout]
      end

      def dockerfile=(val)
        @dockerfile = val.to_s
      end

      def build_timeout=(val)
        raise ArgumentError, "Build Timeout must be an Integer" unless val.is_a?(Integer)
        @build_timeout = val
      end

      def spec
        {id: id, dockerfile: dockerfile, build_timeout: build_timeout, image: image, cmd: cmd, entrypoint: entrypoint,
         env: env, after: after}
      end
    end

  end
end
