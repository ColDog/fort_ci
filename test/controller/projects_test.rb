require "test_helper"

describe FortCI::ProjectsController do
  it "can get this users projects" do
    get_as_user "/projects/"
    assert last_response.ok?, last_response.status
    assert_equal 'User', response_json[:meta][:entity][:type]
  end

  it "can get this teams projects" do
    get_as_user "/projects/", team_id: team.id
    assert last_response.ok?, last_response.status
    assert_equal 'Team', response_json[:meta][:entity][:type]
  end

  it "can get a project" do
    get_as_user "/projects/#{user.projects.first.id}"
  end

  it "can create a project" do
    post_as_user "/projects", name: 'TestTeam'
    assert last_response.ok?, last_response.status
  end

  it "can update a project" do
    patch_as_user "/projects/#{user.projects.first.id}", project: {enabled: false}
    assert last_response.ok?, last_response.status
  end
end
