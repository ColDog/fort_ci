require "test_helper"

describe FortCI::Project do
  it "can create a project" do
    FortCI::Project.create_for_entity user, 'TestUser'
  end

  it "can create a project for a user by a team" do
    FortCI::Project.create_for_entity user, 'TestTeam'
  end

  it "can create a team project owned by a user" do
    FortCI::Project.create_for_entity team, 'TestUser'
  end

  it "can create a team project owned by a team" do
    FortCI::Project.create_for_entity team, 'TestTeam'
  end
end
