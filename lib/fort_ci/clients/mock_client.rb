module FortCI
  class MockClient

    def initialize(username, token)
      @token = token
      @username = username
    end

    def teams
      [
          {id: rand(0..100000), name: 'Random Team'},
          {id: rand(0..100000), name: 'Random Team'},
      ]
    end

    def repo(repo)
      {
          id: rand(1000..100000),
          name: repo,
          owner: 'coldog',
          owner_id: rand(1000..100000),
      }
    end

    def latest_commit(repo)
      "#{rand(1000..100000)}"
    end

    def branches(repo)
      branches = []
      20.times do |i|
        branches << {name: "test/#{i}/branch", commit: "#{rand(1000..100000)}"}
      end
    end

    def file(repo, path)
      "Some File"
    end

    def register_webhook(repo)
      true
    end

    def remove_webhooks(repo)
      true
    end

  end
end
