require 'spec_helper'
require 'dry/swagger/types'
require 'pp'

RSpec.describe Dry::Swagger::ContractParser do
  type_definitions = {
      'Nominal types': %w[
Dry::Swagger::Types::Nominal::Bool
Dry::Swagger::Types::Nominal::Integer
Dry::Swagger::Types::Nominal::Float
Dry::Swagger::Types::Nominal::Decimal
Dry::Swagger::Types::Nominal::String
Dry::Swagger::Types::Nominal::Date
Dry::Swagger::Types::Nominal::DateTime
Dry::Swagger::Types::Nominal::Time
],
      'Strict types': %w[
Dry::Swagger::Types::Strict::Bool
Dry::Swagger::Types::Strict::Integer
Dry::Swagger::Types::Strict::Float
Dry::Swagger::Types::Strict::Decimal
Dry::Swagger::Types::Strict::String
Dry::Swagger::Types::Strict::Date
Dry::Swagger::Types::Strict::DateTime
Dry::Swagger::Types::Strict::Time
],
      'Coercible types': %w[
Dry::Swagger::Types::Coercible::String
Dry::Swagger::Types::Coercible::Integer
Dry::Swagger::Types::Coercible::Float
Dry::Swagger::Types::Coercible::Decimal
],
      'Params types': %w[
Dry::Swagger::Types::Params::Date
Dry::Swagger::Types::Params::DateTime
Dry::Swagger::Types::Params::Time
Dry::Swagger::Types::Params::Bool
Dry::Swagger::Types::Params::Integer
Dry::Swagger::Types::Params::Float
Dry::Swagger::Types::Params::Decimal
],
      'JSON types': %w[
Dry::Swagger::Types::JSON::Date
Dry::Swagger::Types::JSON::DateTime
Dry::Swagger::Types::JSON::Time
Dry::Swagger::Types::JSON::Decimal
]
  }

  schema_types = {
      'Schema types': %w[
int?
str?
bool?
]
  }

  let(:contract) do
    Class.new(ApplicationContract)
  end

  subject { described_class.new }

  describe '#.visit(Contract.schema.ast)' do
    type_definitions.each do |_key, array_of_types|
      context "required(:field).value(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                required(:"field#{index}").value(Object.const_get(type))
              }
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end
      context "required(:field).filled(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                required(:"field#{index}").filled(Object.const_get(type))
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).maybe(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                required(:"field#{index}").maybe(Object.const_get(type))
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).value(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                optional(:"field#{index}").value(Object.const_get(type))
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).filled(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                optional(:"field#{index}").filled(Object.const_get(type))
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).maybe(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                optional(:"field#{index}").maybe(Object.const_get(type))
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).maybe(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                optional(:"field#{index}").maybe(Object.const_get(type))
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).array(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                optional(:"field#{index}").array(Object.const_get(type))
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            required(:field).value(:#{array_of_types})
        end" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:"hash").hash do
                array_of_types.each_with_index.map { |type, index|
                  required(:"field#{index}").value(Object.const_get(type))
                }
              end

            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            required(:field).maybe(:#{array_of_types})
        end" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:"hash").hash do
                array_of_types.each_with_index.map { |type, index|
                  required(:"field#{index}").maybe(Object.const_get(type))
                }
              end

            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            required(:field).filled(:#{array_of_types})
        end" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:"hash").hash do
                array_of_types.each_with_index.map { |type, index|
                  required(:"field#{index}").filled(Object.const_get(type))
                }
              end

            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            optional(:field).value(:#{array_of_types})
        end" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:"hash").hash do
                array_of_types.each_with_index.map { |type, index|
                  optional(:"field#{index}").filled(Object.const_get(type))
                }
              end

            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            optional(:field).maybe(:#{array_of_types})
        end" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:"hash").hash do
                array_of_types.each_with_index.map { |type, index|
                  required(:"field#{index}").filled(Object.const_get(type))
                }
              end

            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            optional(:field).filled(:#{array_of_types})
        end" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:"hash").hash do
                array_of_types.each_with_index.map { |type, index|
                  required(:"field#{index}").filled(Object.const_get(type))
                }
              end

            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end
    end

    schema_types.each do |_key, array_of_types|
      context "required(:field).value(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                required(:"field#{index}").value(:"#{type}")
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end
      context "required(:field).filled(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                required(:"field#{index}").filled(:"#{type}")
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).maybe(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                required(:"field#{index}").maybe(:"#{type}")
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).array(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                required(:"field#{index}").array(:"#{type}")
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).value(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                optional(:"field#{index}").value(:"#{type}")
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).filled(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                optional(:"field#{index}").filled(:"#{type}")
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).maybe(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                optional(:"field#{index}").maybe(:"#{type}")
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).array(:#{array_of_types})" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map { |type, index|
                optional(:"field#{index}").array(:"#{type}")
              }
            end

          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            required(:field).value(:#{array_of_types})
        end" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:"hash").hash do
                array_of_types.each_with_index.map { |type, index|
                  required(:"field#{index}").value(:"#{type}")
                }
              end

            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            required(:field).maybe(:#{array_of_types})
        end" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:"hash").hash do
                array_of_types.each_with_index.map { |type, index|
                  required(:"field#{index}").maybe(:"#{type}")
                }
              end

            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            required(:field).filled(:#{array_of_types})
        end" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:"hash").hash do
                array_of_types.each_with_index.map { |type, index|
                  required(:"field#{index}").filled(:"#{type}")
                }
              end

            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            optional(:field).value(:#{array_of_types})
        end" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:"hash").hash do
                array_of_types.each_with_index.map { |type, index|
                  optional(:"field#{index}").filled(:"#{type}")
                }
              end

            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            optional(:field).maybe(:#{array_of_types})
        end" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:"hash").hash do
                array_of_types.each_with_index.map { |type, index|
                  required(:"field#{index}").filled(:"#{type}")
                }
              end

            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            optional(:field).filled(:#{array_of_types})
        end" do
        it 'should parse all fields correctly without raising error' do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:"hash").hash do
                array_of_types.each_with_index.map { |type, index|
                  required(:"field#{index}").filled(:"#{type}")
                }
              end

            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end
    end
  end

  describe "#.to_swagger" do
    let(:test_contract) do
      Class.new(Dry::Validation::Contract) do
        json do
          required(:string).value(:str?)
          required(:string1).maybe(:str?)
          required(:string2).filled(:str?)

          optional(:string3).value(:str?)
          optional(:string4).maybe(:str?)
          optional(:string5).filled(:str?)

          required(:integer).value(:int?)
          required(:integer1).maybe(:int?)
          required(:integer2).filled(:int?)

          optional(:integer3).value(:int?)
          optional(:integer4).maybe(:int?)
          optional(:integer5).filled(:int?)

          required(:boolean).value(:bool?)
          required(:boolean1).maybe(:bool?)
          required(:boolean2).filled(:bool?)

          optional(:boolean3).value(:bool?)
          optional(:boolean4).maybe(:bool?)
          optional(:boolean5).filled(:bool?)

          required(:date).value(Dry::Swagger::Types::Date)
          required(:date1).maybe(Dry::Swagger::Types::Date)
          required(:date2).filled(Dry::Swagger::Types::Date)

          optional(:date3).value(Dry::Swagger::Types::Date)
          optional(:date4).maybe(Dry::Swagger::Types::Date)
          optional(:date5).filled(Dry::Swagger::Types::Date)

          required(:datetime).value(Dry::Swagger::Types::DateTime)
          required(:datetime1).maybe(Dry::Swagger::Types::DateTime)
          required(:datetime2).filled(Dry::Swagger::Types::DateTime)

          optional(:datetime3).value(Dry::Swagger::Types::DateTime)
          optional(:datetime4).maybe(Dry::Swagger::Types::DateTime)
          optional(:datetime5).filled(Dry::Swagger::Types::DateTime)

          required(:hash).hash do
            required(:string).value(:str?)
            optional(:integer).maybe(:int?)
          end

          optional(:hash1).hash do
            required(:string).value(:str?)
            optional(:integer).maybe(:int?)
          end

          required(:array).array(:int?)
          optional(:array1).array(:str?)

          required(:array2).array(:hash) do
            required(:string).value(:str?)
            optional(:integer).maybe(:int?)
          end

          optional(:array3).array(:hash) do
            required(:string).value(:str?)
            optional(:integer).maybe(:int?)
          end

          required(:with_description).value(:str?, min_size?: 5, max_size?: 10)
          required(:string_with_enum).value(Dry::Swagger::Types::String.enum("test", "test1"))
        end
      end
    end

    describe 'when Contract is passed to parser' do
      context 'and configuration nullable type is :"x-nullable"' do
        let(:expected_result) do
          {:type=>:object,
           :properties=>
               {:string=>{:type=>:string, :"x-nullable"=>false},
                :string1=>{:type=>:string, :"x-nullable"=>true},
                :string2=>{:type=>:string, :"x-nullable"=>false},
                :string3=>{:type=>:string, :"x-nullable"=>false},
                :string4=>{:type=>:string, :"x-nullable"=>true},
                :string5=>{:type=>:string, :"x-nullable"=>false},
                :integer=>{:type=>:integer, :"x-nullable"=>false},
                :integer1=>{:type=>:integer, :"x-nullable"=>true},
                :integer2=>{:type=>:integer, :"x-nullable"=>false},
                :integer3=>{:type=>:integer, :"x-nullable"=>false},
                :integer4=>{:type=>:integer, :"x-nullable"=>true},
                :integer5=>{:type=>:integer, :"x-nullable"=>false},
                :boolean=>{:type=>:boolean, :"x-nullable"=>false},
                :boolean1=>{:type=>:boolean, :"x-nullable"=>true},
                :boolean2=>{:type=>:boolean, :"x-nullable"=>false},
                :boolean3=>{:type=>:boolean, :"x-nullable"=>false},
                :boolean4=>{:type=>:boolean, :"x-nullable"=>true},
                :boolean5=>{:type=>:boolean, :"x-nullable"=>false},
                :date=>{:type=>:string, :format=>:date, :"x-nullable"=>false},
                :date1=>{:type=>:string, :format=>:date, :"x-nullable"=>true},
                :date2=>{:type=>:string, :format=>:date, :"x-nullable"=>false},
                :date3=>{:type=>:string, :format=>:date, :"x-nullable"=>false},
                :date4=>{:type=>:string, :format=>:date, :"x-nullable"=>true},
                :date5=>{:type=>:string, :format=>:date, :"x-nullable"=>false},
                :datetime=>{:type=>:string, :format=>:datetime, :"x-nullable"=>false},
                :datetime1=>{:type=>:string, :format=>:datetime, :"x-nullable"=>true},
                :datetime2=>{:type=>:string, :format=>:datetime, :"x-nullable"=>false},
                :datetime3=>{:type=>:string, :format=>:datetime, :"x-nullable"=>false},
                :datetime4=>{:type=>:string, :format=>:datetime, :"x-nullable"=>true},
                :datetime5=>{:type=>:string, :format=>:datetime, :"x-nullable"=>false},
                :hash=>
                    {:type=>:object,
                     :properties=>
                         {:string=>{:type=>:string, :"x-nullable"=>false},
                          :integer=>{:type=>:integer, :"x-nullable"=>true}},
                     :required=>[:string],
                     :"x-nullable"=>false},
                :hash1=>
                    {:type=>:object,
                     :properties=>
                         {:string=>{:type=>:string, :"x-nullable"=>false},
                          :integer=>{:type=>:integer, :"x-nullable"=>true}},
                     :required=>[:string],
                     :"x-nullable"=>false},
                :array=>
                    {:type=>:array,
                     :items=>{:type=>:integer, :"x-nullable"=>false},
                     :"x-nullable"=>false},
                :array1=>
                    {:type=>:array,
                     :items=>{:type=>:string, :"x-nullable"=>false},
                     :"x-nullable"=>false},
                :array2=>
                    {:type=>:array,
                     :items=>
                         {:type=>:object,
                          :properties=>
                              {:string=>{:type=>:string, :"x-nullable"=>false},
                               :integer=>{:type=>:integer, :"x-nullable"=>true}},
                          :required=>[:string],
                          :"x-nullable"=>false},
                     :"x-nullable"=>false},
                :array3=>
                    {:type=>:array,
                     :items=>
                         {:type=>:object,
                          :properties=>
                              {:string=>{:type=>:string, :"x-nullable"=>false},
                               :integer=>{:type=>:integer, :"x-nullable"=>true}},
                          :required=>[:string],
                          :"x-nullable"=>false},
                     :"x-nullable"=>false},
                :with_description=>
                    {:type=>:string,
                     :description=>"Minimum size: 5, Maximum size: 10",
                     :"x-nullable"=>false},
                :string_with_enum=>
                    {:type=>:string, :enum=>["test", "test1"], :"x-nullable"=>false}},
           :required=>
               [:string,
                :string1,
                :string2,
                :integer,
                :integer1,
                :integer2,
                :boolean,
                :boolean1,
                :boolean2,
                :date,
                :date1,
                :date2,
                :datetime,
                :datetime1,
                :datetime2,
                :hash,
                :array,
                :array2,
                :with_description,
                :string_with_enum]
          }
        end

        before do
          Dry::Swagger::Config::ContractConfiguration.configuration do |config|
            config.nullable_type = :"x-nullable"
          end
        end

        it 'should generate a valid swagger documentation' do
          expect(subject.call(test_contract).to_swagger).to match(expected_result)
        end
      end

      context 'and configuration nullable type is nullable' do
        let(:expected_result) do
          {:type=>:object,
           :properties=>
               {:string=>{:type=>:string, :nullable=>false},
                :string1=>{:type=>:string, :nullable=>true},
                :string2=>{:type=>:string, :nullable=>false},
                :string3=>{:type=>:string, :nullable=>false},
                :string4=>{:type=>:string, :nullable=>true},
                :string5=>{:type=>:string, :nullable=>false},
                :integer=>{:type=>:integer, :nullable=>false},
                :integer1=>{:type=>:integer, :nullable=>true},
                :integer2=>{:type=>:integer, :nullable=>false},
                :integer3=>{:type=>:integer, :nullable=>false},
                :integer4=>{:type=>:integer, :nullable=>true},
                :integer5=>{:type=>:integer, :nullable=>false},
                :boolean=>{:type=>:boolean, :nullable=>false},
                :boolean1=>{:type=>:boolean, :nullable=>true},
                :boolean2=>{:type=>:boolean, :nullable=>false},
                :boolean3=>{:type=>:boolean, :nullable=>false},
                :boolean4=>{:type=>:boolean, :nullable=>true},
                :boolean5=>{:type=>:boolean, :nullable=>false},
                :date=>{:type=>:string, :format=>:date, :nullable=>false},
                :date1=>{:type=>:string, :format=>:date, :nullable=>true},
                :date2=>{:type=>:string, :format=>:date, :nullable=>false},
                :date3=>{:type=>:string, :format=>:date, :nullable=>false},
                :date4=>{:type=>:string, :format=>:date, :nullable=>true},
                :date5=>{:type=>:string, :format=>:date, :nullable=>false},
                :datetime=>{:type=>:string, :format=>:datetime, :nullable=>false},
                :datetime1=>{:type=>:string, :format=>:datetime, :nullable=>true},
                :datetime2=>{:type=>:string, :format=>:datetime, :nullable=>false},
                :datetime3=>{:type=>:string, :format=>:datetime, :nullable=>false},
                :datetime4=>{:type=>:string, :format=>:datetime, :nullable=>true},
                :datetime5=>{:type=>:string, :format=>:datetime, :nullable=>false},
                :hash=>
                    {:type=>:object,
                     :properties=>
                         {:string=>{:type=>:string, :nullable=>false},
                          :integer=>{:type=>:integer, :nullable=>true}},
                     :required=>[:string],
                     :nullable=>false},
                :hash1=>
                    {:type=>:object,
                     :properties=>
                         {:string=>{:type=>:string, :nullable=>false},
                          :integer=>{:type=>:integer, :nullable=>true}},
                     :required=>[:string],
                     :nullable=>false},
                :array=>
                    {:type=>:array,
                     :items=>{:type=>:integer, :nullable=>false},
                     :nullable=>false},
                :array1=>
                    {:type=>:array,
                     :items=>{:type=>:string, :nullable=>false},
                     :nullable=>false},
                :array2=>
                    {:type=>:array,
                     :items=>
                         {:type=>:object,
                          :properties=>
                              {:string=>{:type=>:string, :nullable=>false},
                               :integer=>{:type=>:integer, :nullable=>true}},
                          :required=>[:string],
                          :nullable=>false},
                     :nullable=>false},
                :array3=>
                    {:type=>:array,
                     :items=>
                         {:type=>:object,
                          :properties=>
                              {:string=>{:type=>:string, :nullable=>false},
                               :integer=>{:type=>:integer, :nullable=>true}},
                          :required=>[:string],
                          :nullable=>false},
                     :nullable=>false},
                :with_description=>
                    {:type=>:string,
                     :description=>"Minimum size: 5, Maximum size: 10",
                     :nullable=>false},
                :string_with_enum=>
                    {:type=>:string, :enum=>["test", "test1"], :nullable=>false}},
           :required=>
               [:string,
                :string1,
                :string2,
                :integer,
                :integer1,
                :integer2,
                :boolean,
                :boolean1,
                :boolean2,
                :date,
                :date1,
                :date2,
                :datetime,
                :datetime1,
                :datetime2,
                :hash,
                :array,
                :array2,
                :with_description,
                :string_with_enum]
          }
        end

        before do
          Dry::Swagger::Config::ContractConfiguration.configuration do |config|
            config.nullable_type = :nullable
          end
        end

        it 'should generate a valid swagger documentation' do
          expect(subject.call(test_contract).to_swagger).to match(expected_result)
        end
      end
    end
  end
end
