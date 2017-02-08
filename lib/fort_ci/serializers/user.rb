require "fort_ci/serializers/base"

module FortCI
  module Serializers
    class User < Base
      root_key :user
      attributes :id, :name, :email
    end
  end
end
