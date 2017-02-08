unless FortCI::User.find(email: 'colinwalker270@gmail.com')
  FortCI::User.create(
      name: 'Colin Walker',
      username: 'ColDog',
      email: 'colinwalker270@gmail.com',
      provider_id: '10747761',
      provider: 'mock',
      token: '4d2d6ee0ed690eeb48a36e511e24ca7af92261f5',
  )
end
