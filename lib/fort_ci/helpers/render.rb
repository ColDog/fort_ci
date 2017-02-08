module FortCI
  module Helpers
    module Render

      def render(args)
        status = args[:status] || 200

        type = args.keys[0]
        resource = args[type]

        case type
          when :json
            result = json(resource)
          when :plain
            result = resource
          else
            raise("Type #{type} not recognized")
        end

        halt status, result
      end

      def json(resource)
        content_type "application/json"
        JSON.generate(serializable_resource(resource))
      end

      def serializable_resource(resource)
        if resource.is_a?(Array)
          resource.map { |item| serializable_resource(item) }
        else
          if resource.respond_to?(:serializable_hash)
            resource.serializable_hash
          else
            resource
          end
        end
      end

    end
  end
end
