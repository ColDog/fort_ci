require "erb"

module FortCI
  module Helpers
    module Serialization

      def symbolize_keys(object)
        if object.is_a?(Array)
          object.each_with_index do |item, idx|
            object[idx] = symbolize_keys(item)
          end
        elsif object.is_a?(Hash)
          object.keys.each do |key|
            object[key.to_sym] = symbolize_keys(object.delete(key))
          end
        end
        object
      end

      def load_config_file(filename)
        return nil unless File.exists?(filename)
        YAML.load(ERB.new(File.read(filename)).result)
      end

    end
  end
end
