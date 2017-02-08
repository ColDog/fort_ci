module FortCI
  class BaseSerializer
    attr_reader :object

    def initialize(object, in_collection: false)
      @object = object
      @in_collection = in_collection
    end

    def self.attributes(*attrs)
      @attributes ||= []
      @attributes = (@attributes + attrs.map(&:to_sym)).uniq
    end

    def self.collection(objects)
      objects.map { |object| self.new(object, in_collection: true) }
    end

    def serializable_hash
      hash = {}
      self.class.attributes.each do |attr|
        if self.respond_to?(attr)
          hash[attr] = self.send(attr)
        else
          hash[attr] = @object.send(attr)
        end
      end

      hash
    end

  end
end
