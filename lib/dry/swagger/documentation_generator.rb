module Dry
  module Swagger
    class DocumentationGenerator
      SWAGGER_FIELD_TYPE_DEFINITIONS = {
          "string" => { type: :string },
          "integer" => { type: :integer },
          "boolean" => { type: :boolean },
          "float" => { type: :float },
          "datetime" => { type: :string, format: :datetime },
          "date" => { type: :string, format: :date },
          "time" => { type: :string, format: :time },
      }.freeze

      def initialize(config)
        @config = config
      end

      def generate_documentation(fields)
        documentation = { properties: {}, required: [] }
        fields.each do |field_name, attributes_hash|
          documentation[:properties][field_name] = generate_field_properties(attributes_hash)
          documentation[:required] << field_name if attributes_hash.fetch(:required, true) && @config.enable_required_validation

        rescue Errors::MissingTypeError => e
          raise StandardError.new e.message % { field_name: field_name, valid_types: SWAGGER_FIELD_TYPE_DEFINITIONS.keys, attributes_hash: attributes_hash }
        rescue Errors::MissingHashSchemaError => e
          raise StandardError.new e.message % { field_name: field_name, valid_types: SWAGGER_FIELD_TYPE_DEFINITIONS.keys, attributes_hash: attributes_hash }
        end

        { :type => :object, :properties => documentation[:properties], :required => documentation[:required] }
      end

      def generate_field_properties(attributes_hash)
        if attributes_hash[:type] == 'array'
          items = generate_documentation(attributes_hash.fetch(:keys))
          items =  @config.enable_nullable_validation ?
                       items.merge(@config.nullable_type => attributes_hash.fetch(@config.nullable_type, false)) :
                       items.merge(@config.nullable_type => true)
          documentation = { type: :array, items: items }
        elsif attributes_hash[:array] && attributes_hash.fetch(:type) != 'array'
          items = SWAGGER_FIELD_TYPE_DEFINITIONS.fetch(attributes_hash.fetch(:type))
          items = @config.enable_nullable_validation ?
                      items.merge(@config.nullable_type => attributes_hash.fetch(@config.nullable_type, false)) :
                      items.merge(@config.nullable_type => true)
          documentation = { type: :array, items:  items }
        elsif attributes_hash[:type] == 'hash'
          raise Errors::MissingHashSchemaError.new unless attributes_hash[:keys]
          documentation = generate_documentation(attributes_hash.fetch(:keys))
        else
          documentation = SWAGGER_FIELD_TYPE_DEFINITIONS.fetch(attributes_hash.fetch(:type))
          if attributes_hash[:enum] && @config.enable_enums
            documentation = documentation.merge(enum: attributes_hash.fetch(:enum))
          end

          if attributes_hash[:description] && @config.enable_descriptions
            documentation = documentation.merge(description: attributes_hash.fetch(:description))
          end
        end

        @config.enable_nullable_validation ?
            documentation.merge(@config.nullable_type => attributes_hash.fetch(@config.nullable_type, false)) :
            documentation.merge(@config.nullable_type => true)

      rescue KeyError
        raise Errors::MissingTypeError.new
      end
    end
  end
end
