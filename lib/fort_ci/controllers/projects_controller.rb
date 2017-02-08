require "sinatra/extension"
require "fort_ci/serializers/project_serializer"

module FortCI
  module ProjectsController
    extend Sinatra::Extension

    before("/projects/?*") { protected! }

    get "/projects/?" do
      render json: ProjectSerializer.collection(current_entity.projects), root: :projects
    end

    # post "/projects/?" do
    #   json Project.add_project(current_entity, params[:name]), root: :project
    # end

    get "/projects/:id/?" do
      render json: ProjectSerializer.new(current_entity.projects.with_pk!(params[:id])), root: :project
    end

    # put "/projects/:id/?" do
    #   project = current_entity.projects.find(params[:id])
    #   project.update!(params[:project])
    #   json project, root: :project
    # end
    #
    # delete "/projects/:id/?" do
    #   json current_entity.projects.find(params[:id]).destroy!, root: :project
    # end
    #
    # get "/projects/:id/jobs/?" do
    #   json current_entity.projects.find(params[:id]).jobs, root: :jobs
    # end
    #
    # get "/projects/:id/branches/?" do
    #   json current_entity.projects.find(params[:id]).branches, root: :jobs
    # end
    #
    # get "/projects/:id/pipelines/?" do
    #   json current_entity.projects.find(params[:id]).pipelines, root: :pipelines
    # end

  end
end
