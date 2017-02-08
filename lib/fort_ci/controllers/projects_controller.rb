require "sinatra/extension"
require "fort_ci/serializers/project_serializer"

module FortCI
  module ProjectsController
    extend Sinatra::Extension

    before("/projects/?*") { protected! }

    get "/projects/?" do
      render json: ProjectSerializer.collection(current_entity.projects), root: :projects
    end

    post "/projects/?" do
      json Project.create_for_entity(current_entity, params[:name]), root: :project
    end

    get "/projects/:id/?" do
      render json: ProjectSerializer.new(current_entity.projects.with_pk!(params[:id])), root: :project
    end

    patch "/projects/:id/?" do
      project = current_entity.projects.with_pk!(params[:id])
      project.update(params[:project])
      json ProjectSerializer.new(project), root: :project
    end

    # get "/projects/:id/branches/?" do
    #   json current_entity.projects.find(params[:id]).branches, root: :jobs
    # end

  end
end
