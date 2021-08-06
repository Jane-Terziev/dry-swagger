# Dry::Swagger

Generate a valid and up to date swagger documentation out of your dry-structs and dry-validations

The gem is still work in progress and is not yet fully tested.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dry-swagger'
```

And then execute:

    bundle install

After installing, execute the following command:
    
    rake dry-swagger:install

This will generate configuration files in your project under `project/config`. See Configuration section for more details.

##Usage

####With Dry::Validation::Contract
Lets say we have the following Dry::Validation::Contract definition:
    
    class TestContract < Dry::Validation::Contract
        params do
            required(:some_field).value(:str?, min_size?: 5, max_size?: 10)
            required(:some_array_of_objects).array(:hash) do
                required(:some_nested_attribute).value(:str?)
            end
            required(:some_array_of_integers).array(:int?)
            required(:dto).value(:hash) do
                optional(:some_nested_attribute).maybe(:str?)
            end
        end
    end
    
    parser = Dry::Swagger::ContractParser.new

`parser.call(TestContract)` will set the `keys` of the `parser` object to:
    
    {
        :some_field => {
            :required => true,
            :type => "string",
            :description => "Minimum size: 5, Maximum size: 10"
        },
         :some_array_of_objects => { 
            :required => true,
            :array => true,
            :type => "array",
            :keys => {
                :some_nested_attribute => {
                    :required=>true, :type=>"string"
                }
            }
         },
         :some_array_of_integers => {
            :required=>true, 
            :array=>true, 
            :type=>"integer"
         },
         :dto => {
            :required => true,
            :type => "hash",
            :keys => {
                :some_nested_attribute => {
                    :required => false, 
                    :"x-nullable"=>true, 
                    :type=>"string"
                }
            }
         }
    }

As we can see, the `ContractParser` goes through all the params defined in the
schema and generates a hash. The hash is saved in the `keys` attribute of the parser,
so that we can call `to_swagger` later.

The required key in our result will be set to `true` if the field is defined as
`required(:field_name)`, and `false` if defined as `optional(:field_name)`.

The "x-nullable" key depends on whether we have defined the field as value, maybe or filled.

For nested objects like array of objects or hash, we add a keys field with a definition
for each field inside the nested hash.

If the field is an array of primitive type, the type field will equal to the primitive type, and a
array flag will be set on the field.

Calling `parser.to_swagger` will give the following result:
    
    {
      "type": "object",
      "properties": {
        "some_field": {
          "type": "string",
          "description": "Minimum size: 5, Maximum size: 10",
          "x-nullable": false
        },
        "some_array_of_objects": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "some_nested_attribute": {
                "type": "string",
                "x-nullable": false
              }
            },
            "required": [
              "some_nested_attribute"
            ],
            "x-nullable": false
          },
          "x-nullable": false
        },
        "some_array_of_integers": {
          "type": "array",
          "items": {
            "type": "integer",
            "x-nullable": false
          },
          "x-nullable": false
        },
        "dto": {
          "type": "object",
          "properties": {
            "some_nested_attribute": {
              "type": "string",
              "x-nullable": true
            }
          },
          "required": [
    
          ],
          "x-nullable": false
        }
      },
      "required": [
        "some_field",
        "some_array_of_objects",
        "some_array_of_integers",
        "dto"
      ]
    }

####With Dry::Struct
The `Dry::Swagger::StructParser` works the same as the contract parser.

The required key depends on whether we define the field as attribute or attribute?

The "x-nullable" key depends on whether we define the type as Type or Type.optional.

For more complex types, for example DTO1 | DTO2 or Types::Array.of(DTO1 | DTO2), 
the parser converts the field value to an array of both schemas.

Example:
    
    class DTO1 < Dry::Struct
        attribute :dto1_field, Types::String
    end
    
    class DTO2 < Dry::Struct
        attribute :dto2_field, Types::String
    end
    
    class DTO < Dry::Struct
        attribute :dynamic_dto, DTO1 | DTO2
    end
    parser = Dry::Swagger::StructParser.new
    
    parser.call(DTO)
    => {
         "dynamic_dto": [ # ARRAY
           {
             "type": "hash",
             "required": true,
             "x-nullable": false,
             "keys": {
               "dto1_field": {
                 "type": "string",
                 "required": true,
                 "x-nullable": false
               }
             }
           },
           {
             "type": "hash",
             "required": true,
             "x-nullable": false,
             "keys": {
               "dto2_field": {
                 "type": "string",
                 "required": true,
                 "x-nullable": false
               }
             }
           }
         ]
       }

Calling `parser.to_swagger` will give the following result:
    
    {
      "type": "object",
      "properties": {
        "dynamic_dto": {
          "type": "object",
          "properties": {
            "definition_1": {
              "type": "object",
              "properties": {
                "dto1_field": {
                  "type": "string",
                  "x-nullable": false
                }
              },
              "required": [
                "dto1_field"
              ],
              "x-nullable": false
            },
            "definition_2": {
              "type": "object",
              "properties": {
                "dto2_field": {
                  "type": "string",
                  "x-nullable": false
                }
              },
              "required": [
                "dto2_field"
              ],
              "x-nullable": false
            }
          },
          "example": "Dynamic Field. See Model Definitions",
          "oneOf": [
            {
              "type": "object",
              "properties": {
                "dto1_field": {
                  "type": "string",
                  "x-nullable": false
                }
              },
              "required": [
                "dto1_field"
              ],
              "x-nullable": false
            },
            {
              "type": "object",
              "properties": {
                "dto2_field": {
                  "type": "string",
                  "x-nullable": false
                }
              },
              "required": [
                "dto2_field"
              ],
              "x-nullable": false
            }
          ]
        }
      },
      "required": [
        "dynamic_dto"
      ]
    }

## Overriding fields
You can also modify the fields by passing a block after the .call() method.

    Dry::Swagger::StructParser.new.call(DTO) do |it|
      # types = string/integer/hash/array
      
      # Remove a field
      its.keys = it.keys.except(:field_name) 
      
      # Add new field on root level
      it.keys[:new_field_name] = { type: type, required: true/false, :it.config.nullable_type=>true/false } 
      
      # Add a new field in nested hash/array
      it.keys[:nested_field][:keys][:new_field_name] = { 
        type: type, required: true/false, :it.config.nullable_type=>true/false
      }
      
      # Remove a field in nested hash/array
      it.keys = it.keys[:nested_field][:keys].except(:field_name)
      
      # Add an array or hash
      it.keys[:nested_field] = { 
        type: "array/hash", required: true/false, :it.config.nullable_type=> true/false, keys: {
          # List all nested fields
          new_field: { type: :type, required: true/false, :it.config.nullable_type=>true/false }
        }
      }
      
      # Add an Array of primitive types, type field needs to be the element type(string, integer, float), 
      and add an array: true flag
      
      it.keys[:array_field_name] = { 
        type: type, array: true, required: true/false, :it.config.nullable_type=> true/false 
      }
      
    end.to_swagger()
    
##Custom Configuration For Your Project
You can override default configurations by changing the values in the `config/initializers/dry-swagger.rb` file generated from the rake command in the Installation section.

To modify the descriptions for the Contracts, modify the values in `config/locale/dry-swagger.yml`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Jane-Terziev/dry-swagger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dry-swagger/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dry::Swagger project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dry-swagger/blob/master/CODE_OF_CONDUCT.md).
