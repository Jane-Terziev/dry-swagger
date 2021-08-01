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

      def generate_documentation(fields)
        documentation = { properties: {}, required: [] }
        fields.each do |field_name, attributes_hash|
          documentation[:properties][field_name] = generate_field_properties(attributes_hash)
          documentation[:required] << field_name if attributes_hash[:required]
        end
        { :type => :object, :properties => documentation[:properties], :required => documentation[:required] }
      end

      def generate_field_properties(attributes_hash)
        if attributes_hash[:type] == 'array'
          { type: :array, items: generate_documentation(attributes_hash[:keys]) }
        elsif attributes_hash[:array] && attributes_hash[:type] != 'array'
          items = SWAGGER_FIELD_TYPE_DEFINITIONS.fetch(attributes_hash[:type])
          items = items.merge(::Dry::Swagger.nullable_type => attributes_hash[::Dry::Swagger.nullable_type] | false)
          { type: :array, items:  items}
        elsif attributes_hash[:type] == 'hash'
          generate_documentation(attributes_hash[:keys])
        else
          field = SWAGGER_FIELD_TYPE_DEFINITIONS.fetch(attributes_hash[:type])
          field = field.merge(::Dry::Swagger.nullable_type => attributes_hash[::Dry::Swagger.nullable_type] | false)
          field = field.merge(enum: attributes_hash[:enum]) if attributes_hash[:enum]
          field = field.merge(description: attributes_hash[:description]) if attributes_hash[:description]
          field
        end
      end
    end
  end
end
