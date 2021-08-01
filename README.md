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

Or install it yourself as:

    gem install dry-swagger

## Usage
## Dry::Validation::Contract
    class Contract < Dry::Validation::Contract
        json do
            required(:required_field).value(:str?)
            required(:required_nullable_field).maybe(:str?)
            required(:required_filled_field).filled(:str?)
            
            optional(:optional_field).value(:str?)
            optional(:optional_nullable_field).maybe(:str?)
            optional(:optional_filled_field).filled(:str?)
        end
    end
    
    Dry::Swagger::ContractParser.new.call(Contract).to_swagger
    => {
         "type": "object",
         "properties": {
           "required_field": {
             "type": "string",
             "nullable": false
           },
           "required_nullable_field": {
             "type": "string",
             "nullable": true
           },
           "required_filled_field": {
             "type": "string",
             "nullable": false
           },
           "optional_field": {
             "type": "string",
             "nullable": false
           },
           "optional_nullable_field": {
             "type": "string",
             "nullable": true
           },
           "optional_filled_field": {
             "type": "string",
             "nullable": false
           }
         },
         "required": [
           "required_field",
           "required_nullable_field",
           "required_filled_field"
         ]
       }
#### With nested fields - hash or array
    class Contract < Dry::Validation::Contract
      json do
        required(:array_field).array(:int?)
        required(:array_of_hash).array(:hash) do
          required(:field).value(:str?)
        end
        required(:hash_field).hash do
          required(:field).value(:str?)
        end
      end
    end
    
    Dry::Swagger::ContractParser.new.call(Contract).to_swagger
    => {
         "type": "object",
         "properties": {
           "array_field": {
             "type": "array",
             "items": {
               "type": "integer"
             }
           },
           "array_of_hash": {
             "type": "array",
             "items": {
               "type": "object",
               "properties": {
                 "field": {
                   "type": "string",
                   "x-nullable": false
                 }
               },
               "required": [
                 "field"
               ]
             }
           },
           "hash_field": {
             "type": "object",
             "properties": {
               "field": {
                 "type": "string",
                 "x-nullable": false
               }
             },
             "required": [
               "field"
             ]
           }
         },
         "required": [
           "array_field",
           "array_of_hash",
           "hash_field"
         ]
       }

### With Dry::Struct
    class DTO < Dry::Struct
      attribute  :required_string, Types::String
      attribute  :required_nullable_string, Types::String.optional
      attribute  :required_string_with_enum, Types::String.enum('enum1')
      attribute? :optional_string, Types::String
      attribute? :optional_nullable_string, Types::String.optional
    end
    
    Dry::Swagger::StructParser.new.call(DTO).to_swagger
    => {
         "type": "object",
         "properties": {
           "required_string": {
             "type": "string",
             "x-nullable": false
           },
           "required_nullable_string": {
             "type": "string",
             "x-nullable": true
           },
           "required_string_with_enum": {
             "type": "string",
             "enum": [
               "enum1"
             ],
             "x-nullable": false
           },
           "optional_string": {
             "type": "string",
             "x-nullable": false
           },
           "optional_nullable_string": {
             "type": "string",
             "x-nullable": true
           }
         },
         "required": [
           "required_string",
           "required_nullable_string",
           "required_string_with_enum"
         ]
       }
#### With nested fields
    class NestedDTO < Dry::Struct
      attribute  :required_string, Types::String
      attribute  :required_nullable_string, Types::String.optional
      attribute  :required_string_with_enum, Types::String.enum('enum1')
      attribute? :optional_string, Types::String
      attribute? :optional_nullable_string, Types::String.optional
    end
    
    class DTO < Dry::Struct
      attribute  :array_of_integer, Types::Array.of(Types::Integer)
      attribute  :array_of_objects, Types::Array.of(NestedDTO)
      attribute  :dto, NestedDTO
    end
    
    Dry::Swagger::StructParser.new.call(DTO).to_swagger
    => {
      "type": "object",
      "properties": {
        "array_of_integer": {
          "type": "array",
          "items": {
            "type": "integer"
          },
          "x-nullable": false
        },
        "array_of_objects": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "required_string": {
                "type": "string",
                "x-nullable": false
              },
              "required_nullable_string": {
                "type": "string",
                "x-nullable": true
              },
              "required_string_with_enum": {
                "type": "string",
                "enum": [
                  "enum1"
                ],
                "x-nullable": false
              },
              "optional_string": {
                "type": "string",
                "x-nullable": false
              },
              "optional_nullable_string": {
                "type": "string",
                "x-nullable": true
              }
            },
            "required": [
              "required_string",
              "required_nullable_string",
              "required_string_with_enum"
            ]
          },
          "x-nullable": false
        },
        "dto": {
          "type": "object",
          "properties": {
            "required_string": {
              "type": "string",
              "x-nullable": false
            },
            "required_nullable_string": {
              "type": "string",
              "x-nullable": true
            },
            "required_string_with_enum": {
              "type": "string",
              "enum": [
                "enum1"
              ],
              "x-nullable": false
            },
            "optional_string": {
              "type": "string",
              "x-nullable": false
            },
            "optional_nullable_string": {
              "type": "string",
              "x-nullable": true
            }
          },
          "required": [
            "required_string",
            "required_nullable_string",
            "required_string_with_enum"
          ],
          "x-nullable": false
        }
      },
      "required": [
        "array_of_integer",
        "array_of_objects",
        "dto"
      ]
    }
## Custom Configuration For Your Project
You can override default configurations by creating a file in config/initializers/dry-swagger.rb and changing the following values.

    Dry::Swagger::Config::StructConfiguration.configuration do |config|
      config.enable_required_validation = true / false       
      config.enable_nullable_validation = true / false
      config.enable_enums = true / false
      config.enable_descriptions = true / false
      config.nullable_type = :"x-nullable" / :nullable
    end
    
    Dry::Swagger::Config::ContractConfiguration.configuration do |config|
      config.enable_required_validation = true / false       
      config.enable_nullable_validation = true / false
      config.enable_enums = true / false
      config.enable_descriptions = true / false
      config.nullable_type = :"x-nullable" / :nullable
    end
        
By default, all these settings are true, and nullable_type is :"x-nullable".
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Jane-Terziev/dry-swagger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dry-swagger/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dry::Swagger project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dry-swagger/blob/master/CODE_OF_CONDUCT.md).
