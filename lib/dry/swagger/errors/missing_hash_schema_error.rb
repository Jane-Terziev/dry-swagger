module Dry
  module Swagger
    module Errors
      class MissingHashSchemaError < StandardError
        def message
          "Could not generate documentation for field %{field_name}. The field is defined as hash,
          but the schema is not defined.
          Valid types are: %{valid_types}.
          The parser has generated the following definition for the field: %{field_name}: %{definition}
          "
        end
      end
    end
  end
end
