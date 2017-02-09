require "sinatra/extension"
require "fort_ci/serializers/runner_job_serializer"

module FortCI
  module RunnerController
    extend Sinatra::Extension

    before("/runner/?*") { protected_runner! }

    get "/runner/pop/?" do
      render json: RunnerJobSerializer.new(Job.pop(current_runner)), root: :job
    end

    post "/runner/job_status?" do
      Job.update_status(current_runner, params[:id], params[:status], params[:output_url])
      render json: {ok: true}
    end

    post "/runner/reject" do
      Job.reject(current_runner, params[:id])
      render json: {ok: true}
    end
  end
end
