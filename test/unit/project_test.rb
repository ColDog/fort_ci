require "test_helper"

describe FortCI::Project do
  it "can create a project" do
    count = FortCI::Project.count
    FortCI::Project.create_for_entity user, 'TestUser'
    assert_equal count + 1, FortCI::Project.count
  end

  it "can create a project for a user by a team" do
    count = FortCI::Project.count
    FortCI::Project.create_for_entity user, 'TestTeam'
    assert_equal count + 1, FortCI::Project.count
  end

  it "can create a team project owned by a user" do
    count = FortCI::Project.count
    FortCI::Project.create_for_entity team, 'TestUser'
    assert_equal count + 1, FortCI::Project.count
  end

  it "can create a team project owned by a team" do
    count = FortCI::Project.count
    FortCI::Project.create_for_entity team, 'TestTeam'
    assert_equal count + 1, FortCI::Project.count
  end
end
