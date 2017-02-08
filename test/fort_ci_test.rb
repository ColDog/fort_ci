require 'test_helper'

describe FortCI do
  it "has a version number" do
    refute_nil FortCI::VERSION
  end

  it "has some configuration" do
    refute_nil FortCI.config
    refute_nil FortCI.config.database
  end
end
