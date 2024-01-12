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

      def initialize
        @config = Config::SwaggerConfiguration
      end

      def from_struct(struct)
        generate_documentation(DryStructParser::StructSchemaParser.new.call(struct).keys)
      end

      def from_validation(validation)
        generate_documentation(DryValidationParser::ValidationSchemaParser.new.call(validation).keys)
      end

      def generate_documentation(fields)
        documentation = { properties: {}, required: [] }
        fields.each do |field_name, definition|
          documentation[:properties][field_name] = generate_field_properties(definition)
          if definition.is_a?(Hash)
            documentation[:required] << field_name if definition.fetch(:required, true) && @config.enable_required_validation
          else
            documentation[:required] << field_name if definition[0].fetch(:required, true) && @config.enable_required_validation
          end

        rescue Errors::MissingTypeError => e
          raise StandardError.new e.message % { field_name: field_name, valid_types: SWAGGER_FIELD_TYPE_DEFINITIONS.keys, definition: definition }
        rescue Errors::MissingHashSchemaError => e
          raise StandardError.new e.message % { field_name: field_name, valid_types: SWAGGER_FIELD_TYPE_DEFINITIONS.keys, definition: definition }
        end

        { :type => :object, :properties => documentation[:properties], :required => documentation[:required] }
      end

      def generate_field_properties(definition)
        return generate_for_sti_type(definition) if definition.is_a?(Array)

        if definition[:type] == 'array' || definition[:array]
          documentation = generate_for_array(definition)
        elsif definition[:type] == 'hash'
          documentation = generate_for_hash(definition)
        else
          documentation = generate_for_primitive_type(definition)
        end
        @config.enable_nullable_validation ?
            documentation.merge(@config.nullable_type => definition.fetch(:nullable, false)) :
            documentation.merge(@config.nullable_type => true)

      rescue KeyError
        raise Errors::MissingTypeError.new
      end

      def generate_for_sti_type(definition)
        properties = {}

        definition.each_with_index do |_, index|
          properties["definition_#{index + 1}"] = generate_field_properties(definition[index])
        end

        documentation = {
            type: :object,
            properties: properties,
            example: 'Dynamic Field. See Model Definitions'
        }

        if definition[0][:type] == 'array'
          definition.each { |it| it[:type] = 'hash'}
          documentation[:oneOf] = definition.map{ |it| generate_field_properties(it) }
          { type: :array, items: documentation }
        else
          documentation[:oneOf] = definition.map{ |it| generate_field_properties(it) }
          documentation
        end
      end

      def generate_for_array(definition)
        items = array_of_primitive_type?(definition) ?
                    SWAGGER_FIELD_TYPE_DEFINITIONS.fetch(definition.fetch(:type)) :
                    generate_documentation(definition.fetch(:keys))
        items =  @config.enable_nullable_validation ?
                     items.merge(@config.nullable_type => definition.fetch(:nullable, false)) :
                     items.merge(@config.nullable_type => true)
        { type: :array, items: items }
      end

      def generate_for_hash(definition)
        raise Errors::MissingHashSchemaError.new unless definition[:keys]
        generate_documentation(definition.fetch(:keys))
      end

      def generate_for_primitive_type(definition)
        documentation = SWAGGER_FIELD_TYPE_DEFINITIONS.fetch(definition.fetch(:type))
        documentation = documentation.merge(enum: definition.fetch(:enum)) if definition[:enum] && @config.enable_enums
        documentation = documentation.merge(description: definition.fetch(:description)) if definition[:description] &&
                                                                                            @config.enable_descriptions
        documentation
      end

      def array_of_primitive_type?(definition)
        definition[:array] && definition.fetch(:type) != 'array'
      end
    end
  end
end
