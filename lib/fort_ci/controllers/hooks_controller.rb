require "sinatra/extension"
require "fort_ci/models/event"

module FortCI
  module HooksController
    extend Sinatra::Extension

    post "/hooks/github" do

      event = {}
      if params[:ref]

        event[:name] = 'git:push'
        if params[:ref].split('/')[1] == 'heads'
          event[:branch] = params[:ref].split('refs/heads/')[-1]
        end

        event[:commit] = params[:after]
        event[:project] = Project.find(repo_id: params[:repository][:id], repo_provider: 'github')

      elsif params[:pull_request]

        event[:name] = 'git:pull_request'
        event[:commit] = params[:pull_request][:head][:sha]
        event[:branch] = params[:pull_request][:head][:ref]
        event[:project] = Project.find(repo_id: params[:pull_request][:head][:repo][:id], repo_provider: 'github')
        event[:pull_request] = true

      end

      evt = Event.new(event)
      evt.execute

      head 200
    end

  end
end
