unless FortCI::User.find(email: 'colintest@gmail.com')
  FortCI::User.create(
      name: 'Colin Walker',
      username: 'ColDog',
      email: 'colintest@gmail.com',
      provider_id: 'test',
      provider: 'mock',
      token: 'test',
  )
end

unless FortCI::Team.find(name: 'TestTeam')
  user = FortCI::User.find(email: 'colintest@gmail.com')
  team = FortCI::Team.create(
      name: 'TestTeam',
      provider: 'mock',
      provider_id: '123456',
  )

  FortCI::DB[:user_teams].insert(user_id: user.id, team_id: team.id)
end


unless FortCI::Project.find(name: 'TestProject')
  user = FortCI::User.find(email: 'colintest@gmail.com')
  FortCI::Project.create(name: 'TestProject', user_id: user.id, repo_owner_id: user.provider_id)
end

unless FortCI::User.find(email: 'colinwalker270@gmail.com')
  FortCI::User.create(
      name: 'Colin Walker',
      username: 'ColDog',
      email: 'colinwalker270@gmail.com',
      provider_id: '10747761',
      provider: 'github',
      token: '4d2d6ee0ed690eeb48a36e511e24ca7af92261f5',
  )
end

unless FortCI::Project.find(name: 'ci-sample')
  FortCI::Project.create(
      name: 'ci-sample',
      user_id: FortCI::User.find(email: 'colinwalker270@gmail.com').id,
      repo_provider: 'github',
      repo_id: '62962564',
      repo_owner_id: '10747761',
      enabled: true,
  )
end
