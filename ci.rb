#!/usr/bin/env ruby

require "bundler/setup"
require "fort_ci"

class FortCIPipeline < FortCI::Pipelines::Definition
  RUBY_VERSIONS = %w(2.2.6 2.3.3 2.4.0)
  DB_IMAGES = %w(mysql:5.7 mysql:5.6)
  DB_ENV = {
      mysql: %w(MYSQL_USER=dbuser MYSQL_PASSWORD=pass MYSQL_ROOT_PASSWORD=pass MYSQL_DATABASE=fort_ci),
      postgres: [],
  }

  include FortCI::Pipelines::Builders::Basic

  stage         :main,      description: 'Start 1 Basic Job', jobs: DB_IMAGES.length * RUBY_VERSIONS.length
  ensure_stage  :publisher, description: 'Publish results',   jobs: 0
  register

  def main
    RUBY_VERSIONS.each do |version|
      DB_IMAGES.each do |db_image|
        create_fort_job db_image, version
      end
    end
  end

  def publisher
  end

  def create_fort_job(db_image, version)
    db_name = db_image.split(':')[0].to_sym

    create_job FortCI::Pipelines::JobSpec.new do |spec|

      spec.service do |srvc|
        srvc.id = 'db'
        srvc.image = db_image
        srvc.env = DB_ENV[db_name]
      end

      spec.build do |build|
        build.id = 'app'
        build.dockerfile = '.'
        build.template = { version: version }
      end

      spec.command do |cmd|
        cmd.id = 'test'
        cmd.cmd = 'bundle install'
      end

      spec.command do |cmd|
        cmd.id = 'test'
        cmd.cmd = 'rake test'
      end

    end
  end

end

FortCI.deregister_pipeline_definition FortCI::Pipelines::StandardDefinition

FortCI.run_single
