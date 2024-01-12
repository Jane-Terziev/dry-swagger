# Dry::Swagger

Generate a valid and up to date swagger documentation out of your dry-structs and dry-validations

The gem is still work in progress and is not yet fully tested.
## IMPORTANT:

If you are upgrading from version 1 to version 2, you will need to replace: 
    
    Dry::Swagger::StructParser.new.call(struct)
with 

    Dry::Swagger::DocumentationGenerator.new.from_struct(struct) 
and replace 
    
    Dry::Swagger::ContractParser.new.call(contract)
with 
    
    Dry::Swagger::DocumentationGenerator.new.from_validation(contract).

For the configuration file in project/config/initializers/dry-swagger.rb, you will need to replace:

    Dry::Swagger::Config::ContractConfiguration -> Dry::Swagger::Config::SwaggerConfiguration
you do not need both ContractConfiguration and StructConfiguration.
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

## Usage

#### With Dry::Validation::Contract
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
    
    Dry::Swagger::DocumentationGenerator.new.from_validation(TestContract)
    => {
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

#### With Dry::Struct
    class DTO1 < Dry::Struct
        attribute :dto1_field, Types::String
    end
    
    class DTO2 < Dry::Struct
        attribute :dto2_field, Types::String
    end
    
    class DTO < Dry::Struct
        attribute :dynamic_dto, DTO1 | DTO2
    end

    Dry::Swagger::DocumentationGenerator.new.from_struct(DTO)
    => {
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
The documentation generator returns the result as a hash, so you can easily modify it based on your needs.
    
## Custom Configuration For Your Project
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
