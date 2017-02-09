require "sinatra/extension"
require "fort_ci/models/event"

module FortCI
  module EventsController
    extend Sinatra::Extension

    before("/events/?*") { protected! }

    post "/events/?" do
      # authorizes the event
      current_user.projects.with_pk!(params[:project_id]) if params[:project_id]

      event = Event.new(
          project_id: params[:project_id],
          name: params[:name],
      )
      event.execute
      render json: event, root: :event
    end

  end
end
