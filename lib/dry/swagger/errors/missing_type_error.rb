module Dry
  module Swagger
    module Errors
      class MissingTypeError < StandardError
        def message
          "Could not generate documentation for field %{field_name}. The field is missing a type.
          If the field you have defined is an array, you must specify the type of the elements in that array.
          Valid types are: %{valid_types}.
          The parser has generated the following definition for the field: %{field_name}: %{attributes_hash}.
          "
        end
      end
    end
  end
end
