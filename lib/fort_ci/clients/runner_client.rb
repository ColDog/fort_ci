module FortCI
  class RunnerError < RuntimeError
    attr_accessor :body, :status

    def initialize(body, status)
      @body = body
      @status = status
    end

    def message
      "Runner returned #{@status}"
    end
  end

  module RunnerClient
    def cancel
      if worker
        res = conn.delete("/jobs/#{CGI::escape(key)}")
        if res.status < 200 || res.status > 300
          raise RunnerError.new(res.body, res.status)
        end
      end
    ensure
      update(status: 'CANCELLED')
    end

    def output
      res = conn.get("/jobs/#{CGI::escape(key)}")
      if res.status < 200 || res.status > 300
        raise RunnerError.new(res.body, res.status)
      end

      JSON.parse(res.body)
    end

    def conn
      @conn = Faraday.new(url: "http://#{worker}") do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end
end