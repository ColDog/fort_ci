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
        JSON.generate(resource)
      end

    end
  end
end
