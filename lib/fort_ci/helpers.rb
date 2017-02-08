module FortCI
  module Helpers
    def symbolize_keys(object)
      if object.is_a?(Array)
        object.each_with_index do |item, idx|
          object[idx] = symbolize_keys(item)
        end
      elsif object.is_a?(Hash)
        object.each do |key, value|
          object[key] = symbolize_keys(value)
        end
      end
      object
    end
  end
end
