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
      if repo == "TestTeam"
        {
            id: rand(1000..100000),
            name: repo,
            owner: 'coldog',
            owner_id: '123456', # same as seeder
            owner_type: :team, # or :user
        }
      else
        {
            id: rand(1000..100000),
            name: repo,
            owner: 'coldog',
            owner_id: 'test', # same as seeder
            owner_type: :user, # or :user
        }
      end
    end

    def latest_commit(repo)
      {
          sha: "asdfasdfa",
          branch: "test/test",
      }
    end

    def branches(repo)
      branches = []
      20.times do |i|
        branches << {name: "test/#{i}/branch", commit: "#{rand(1000..100000)}"}
      end
    end

    def file(repo, path)
      "setup:\n- echo 'setup'\ntest:\n- echo 'test'\n"
    end

    def register_webhooks(repo)
      true
    end

    def remove_webhooks(repo)
      true
    end

  end
end
