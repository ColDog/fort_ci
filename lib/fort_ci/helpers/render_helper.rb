module FortCI
  module RenderHelper

    def render(args)
      status = args[:status] || 200

      type = args.keys[0]
      resource = args[type]

      case type
        when :json
          result = json(resource, root: args[:root])
        when :plain
          result = resource
        else
          raise("Type #{type} not recognized")
      end

      halt status, result
    end

    def json(resource, root: nil)
      content_type "application/json"
      if root
        result = {root => serializable_resource(resource)}
      else
        result = serializable_resource(resource)
      end
      JSON.generate(result)
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
