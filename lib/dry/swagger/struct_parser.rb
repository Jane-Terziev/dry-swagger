module Dry
  module Swagger
    class StructParser
      SWAGGER_FIELD_TYPE_DEFINITIONS = {
          "String" => { type: :string },
          "Integer" => { type: :integer },
          "TrueClass | FalseClass" => { type: :boolean },
          "BigDecimal" => { type: :decimal },
          "Float" => { type: :float },
          "DateTime" => { type: :string, format: :datetime },
          "Date" => { type: :string, format: :date },
          "Time" => { type: :string, format: :time }
      }

      def call(dto)
        documentation = generate_fields_documentation(dto.schema)
        { :type => :object, :properties => documentation[:properties], :required => documentation[:required]}
      end

      def generate_fields_documentation(dto_schema)
        documentation = { properties: {}, required: [] }
        dto_schema.name_key_map.each do |name, schema_key_object|
          documentation[:properties][name] = schema_key_object.type.optional? ?
                                                 generate_field_properties(schema_key_object.type.right, true) :
                                                 generate_field_properties(schema_key_object.type, false)

          documentation[:required] << name if ::Dry::Swagger.struct_enable_required_validation && schema_key_object.required?
        end
        documentation
      end

      def generate_field_properties(type, nullable)
        field_type = type.name
        if SWAGGER_FIELD_TYPE_DEFINITIONS[field_type] # IS PRIMITIVE FIELD?
          definition = SWAGGER_FIELD_TYPE_DEFINITIONS[field_type]
          definition = definition
          if is_enum?(type.class.name) && ::Dry::Swagger.struct_enable_enums
            enums = type.values
            enums += [nil] if nullable
            definition = definition.merge(enum: enums)
          end
        elsif is_array?(field_type)
          definition = { type: :array }
          if is_primitive?(type.type.member.name)
            definition = definition
            definition = definition.merge(items: SWAGGER_FIELD_TYPE_DEFINITIONS[type.type.member.name])
          else
            schema = is_array_with_dynamic_schema?(type.type.member) ? type.type.member.left : type.type.member
            definition = definition.merge(items: call(schema))
          end
        else
          schema = is_dynamic_schema?(type) ? type.left : type
          definition = call(schema)
        end

        ::Dry::Swagger.struct_enable_nullable_validation ? definition.merge(::Dry::Swagger.nullable_type => nullable) : definition
      end

      private

      def is_enum?(class_name)
        class_name == 'Dry::Types::Enum'
      end

      def is_array?(type_name)
        type_name == 'Array'
      end

      def is_primitive?(type_name)
        !SWAGGER_FIELD_TYPE_DEFINITIONS[type_name].nil?
      end

      def is_array_with_dynamic_schema?(member)
        member.respond_to?(:right)
      end

      def is_dynamic_schema?(type)
        !type.respond_to?(:schema)
      end
    end
  end
end