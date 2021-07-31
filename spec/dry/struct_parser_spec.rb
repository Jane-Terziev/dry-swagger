require 'spec_helper'
require 'dry/swagger/types'
require 'json'

RSpec.describe Dry::Swagger::StructParser do
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

  let!(:dto) { Class.new(Dry::Struct) }
  let!(:test_dto) { Class.new(Dry::Struct) }
  let!(:test_dto1) { Class.new(Dry::Struct) }

  subject { described_class.new }

  describe '#.call(dto)' do
    describe 'with attribute :field' do
      type_definitions.each do |key, array|
        context key.to_s do
          it 'should parse all fields correctly without raising error' do
            array.each_with_index { |type, index| dto.attribute :"field#{index}", Object.const_get(type) }
            expect { subject.call(dto) }.to_not raise_error
          end
        end
      end

      context 'String.enum(field)' do
        it 'should parse all fields correctly without raising error' do
          dto.attribute :field, Dry::Swagger::Types::String.enum("test1", "test2")
          expect { subject.call(dto) }.to_not raise_error
        end
      end

      context 'String.enum(field => value)' do
        it 'should parse all fields correctly without raising error' do
          dto.attribute :field, Dry::Swagger::Types::String.enum("test1" => 0, "test2" => 1)
          expect { subject.call(dto) }.to_not raise_error
        end
      end

      context 'nested TestDTO' do
        it 'should parse all fields correctly without raising error' do
          dto.attribute :custom_type, test_dto
          expect { subject.call(dto) }.to_not raise_error
        end
      end

      context 'nested TestDTO.optional' do
        it 'should parse all fields correctly without raising error' do
          dto.attribute :custom_type, test_dto.optional
          expect { subject.call(dto) }.to_not raise_error
        end
      end

      context 'Array.of(TestDTO)' do
        it 'should parse all fields correctly without raising error' do
          dto.attribute :custom_type, Dry::Swagger::Types::Array.of(test_dto)
          expect { subject.call(dto) }.to_not raise_error
        end
      end

      context 'Array.of(TestDTO).optional' do
        it 'should parse all fields correctly without raising error' do
          dto.attribute :custom_type, Dry::Swagger::Types::Array.of(test_dto).optional
          expect { subject.call(dto) }.to_not raise_error
        end
      end

      context "Array.of(Integer)" do
        it 'should parse all fields correctly without raising error' do
          dto.attribute :custom_type, Dry::Swagger::Types::Array.of(Dry::Swagger::Types::Integer)
          expect { subject.call(dto) }.to_not raise_error
        end
      end

      context "Array.of(Integer).optional" do
        it 'should parse all fields correctly without raising error' do
          dto.attribute :custom_type, Dry::Swagger::Types::Array.of(Dry::Swagger::Types::Integer).optional
          expect { subject.call(dto) }.to_not raise_error
        end
      end

      context "Array.of(DTO | DTO)" do
        it 'should parse all fields correctly without raising error' do
          dto.attribute :custom_type, Dry::Swagger::Types::Array.of(test_dto | test_dto1)
          expect { subject.call(dto) }.to_not raise_error
        end
      end

      context "Array.of(DTO | DTO).optional" do
        it 'should parse all fields correctly without raising error' do
          dto.attribute :custom_type, Dry::Swagger::Types::Array.of(test_dto | test_dto1).optional
          expect { subject.call(dto) }.to_not raise_error
        end
      end
    end

    describe 'with attribute :field, type.optional' do
      type_definitions.each do |key, array|
        context key.to_s do
          it 'should parse all fields correctly without raising error' do
            array.each_with_index {|type, index| dto.attribute :"field#{index}", Object.const_get(type).optional }
            expect { subject.call(dto) }.to_not raise_error
          end
        end
      end

      context 'String.enum(field)' do
        it 'should parse all fields correctly without raising error' do
          dto.attribute :field, Dry::Swagger::Types::String.enum("test1", "test2").optional
          expect { subject.call(dto) }.to_not raise_error
        end
      end

      context 'String.enum(field => value)' do
        it 'should parse all fields correctly without raising error' do
          dto.attribute :field, Dry::Swagger::Types::String.enum("test1" => 0, "test2" => 1).optional
          expect { subject.call(dto) }.to_not raise_error
        end
      end
    end

    describe 'with attribute? :field' do
      type_definitions.each do |key, array|
        context key.to_s do
          it 'should parse all fields correctly without raising error' do
            array.each_with_index {|type, index| dto.attribute? :"field#{index}", Object.const_get(type) }
            expect { subject.call(dto) }.to_not raise_error
          end
        end
      end

      context 'String.enum(field)' do
        it 'should parse all fields correctly without raising error' do
          dto.attribute? :field, Dry::Swagger::Types::String.enum("test1", "test2")
          expect { subject.call(dto) }.to_not raise_error
        end
      end

      context 'String.enum(field => field)' do
        it 'should parse all fields correctly without raising error' do
          dto.attribute? :field, Dry::Swagger::Types::String.enum("test1" => 0, "test2" => 1)
          expect { subject.call(dto) }.to_not raise_error
        end
      end
    end
    describe 'attribute? :field, type.optional' do
      type_definitions.each do |key, array|
        context key.to_s do
          it 'should parse all fields correctly without raising error' do
            array.each_with_index {|type, index| dto.attribute? :"field#{index}", Object.const_get(type).optional }
            expect { subject.call(dto) }.to_not raise_error
          end
        end
      end

      context 'String.enum(field)' do
        it 'should parse all fields correctly without raising error' do
          dto.attribute? :field, Dry::Swagger::Types::String.enum("test1", "test2").optional
          expect { subject.call(dto) }.to_not raise_error
        end
      end

      context 'String.enum(field => value)' do
        it 'should parse all fields correctly without raising error' do
          dto.attribute? :field, Dry::Swagger::Types::String.enum("test1" => 0, "test2" => 1).optional
          expect { subject.call(dto) }.to_not raise_error
        end
      end
    end

    describe "when a dto object is passed" do
      nested_dto = Class.new(Dry::Struct) do
        attribute :required_string, Dry::Swagger::Types::String
        attribute :required_string_or_nil, Dry::Swagger::Types::String.optional
        attribute? :optional_string, Dry::Swagger::Types::String
        attribute? :optional_string_or_nil, Dry::Swagger::Types::String.optional
      end

      let!(:dto) do
        Class.new(Dry::Struct) do
          attribute :required_string, Dry::Swagger::Types::String
          attribute :required_string_or_nil, Dry::Swagger::Types::String.optional
          attribute? :optional_string, Dry::Swagger::Types::String
          attribute? :optional_string_or_nil, Dry::Swagger::Types::String.optional

          attribute :required_string_with_enum, Dry::Swagger::Types::String.enum('test1', 'test2')
          attribute :required_string_or_nil_with_enum, Dry::Swagger::Types::String.enum('test1', 'test2').optional
          attribute? :optional_string_with_enum, Dry::Swagger::Types::String.enum('test1', 'test2')
          attribute? :optional_string_or_nil_with_enum, Dry::Swagger::Types::String.enum('test1', 'test2').optional

          attribute :required_integer, Dry::Swagger::Types::Integer
          attribute :required_integer_or_nil, Dry::Swagger::Types::Integer.optional
          attribute? :optional_integer, Dry::Swagger::Types::Integer
          attribute? :optional_integer_or_nil, Dry::Swagger::Types::Integer.optional

          attribute :required_boolean, Dry::Swagger::Types::Bool
          attribute :required_boolean_or_nil, Dry::Swagger::Types::Bool.optional
          attribute? :optional_boolean, Dry::Swagger::Types::Bool
          attribute? :optional_boolean_or_nil, Dry::Swagger::Types::Bool.optional

          attribute :required_date, Dry::Swagger::Types::Date
          attribute :required_date_or_nil, Dry::Swagger::Types::Date.optional
          attribute? :optional_date, Dry::Swagger::Types::Date
          attribute? :optional_date_or_nil, Dry::Swagger::Types::Date.optional

          attribute :required_date_time, Dry::Swagger::Types::DateTime
          attribute :required_date_time_or_nil, Dry::Swagger::Types::DateTime.optional
          attribute? :optional_date_time, Dry::Swagger::Types::DateTime
          attribute? :optional_date_time_or_nil, Dry::Swagger::Types::DateTime.optional

          attribute :required_time, Dry::Swagger::Types::Time
          attribute :required_time_or_nil, Dry::Swagger::Types::Time.optional
          attribute? :optional_time, Dry::Swagger::Types::Time
          attribute? :optional_time_or_nil, Dry::Swagger::Types::Time.optional

          attribute :hash do
            attribute :required_string, Dry::Swagger::Types::String
            attribute :required_string_or_nil, Dry::Swagger::Types::String.optional
            attribute? :optional_string, Dry::Swagger::Types::String
            attribute? :optional_string_or_nil, Dry::Swagger::Types::String.optional
          end

          attribute :required_array_of_values, Dry::Swagger::Types::Array.of(Dry::Swagger::Types::Integer)
          attribute :required_array_of_values_or_nil, Dry::Swagger::Types::Array.of(Dry::Swagger::Types::Integer).optional
          attribute? :optional_array_of_values, Dry::Swagger::Types::Array.of(Dry::Swagger::Types::Integer)
          attribute? :optional_array_of_values_or_nil, Dry::Swagger::Types::Array.of(Dry::Swagger::Types::Integer).optional

          attribute :required_array_of_nested_dto, Dry::Swagger::Types::Array.of(nested_dto)
          attribute :required_array_of_nested_dto_or_nil, Dry::Swagger::Types::Array.of(nested_dto).optional
          attribute? :optional_array_of_nested_dto, Dry::Swagger::Types::Array.of(nested_dto)
          attribute? :optional_array_of_nested_dto_or_nil, Dry::Swagger::Types::Array.of(nested_dto).optional

          attribute :required_nested_dto, nested_dto
          attribute :required_nested_dto_or_nil, nested_dto.optional
          attribute? :optional_nested_dto, nested_dto
          attribute? :optional_nested_dto_or_nil, nested_dto.optional
        end
      end

      context 'when configuration nullable type is set to x-nullable' do
        let(:expected_result) do
          {
              :type=>:object, :properties=>{
              :required_string=>{:type=>:string, :"x-nullable"=>false},
              :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
              :optional_string=>{:type=>:string, :"x-nullable"=>false},
              :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
              :required_string_with_enum=>{:type=>:string, :enum=>["test1", "test2"], :"x-nullable"=>false},
              :required_string_or_nil_with_enum=>{:type=>:string, :enum=>["test1", "test2", nil], :"x-nullable"=>true},
              :optional_string_with_enum=>{:type=>:string, :enum=>["test1", "test2"], :"x-nullable"=>false},
              :optional_string_or_nil_with_enum=>{:type=>:string, :enum=>["test1", "test2", nil], :"x-nullable"=>true},
              :required_integer=>{:type=>:integer, :"x-nullable"=>false},
              :required_integer_or_nil=>{:type=>:integer, :"x-nullable"=>true},
              :optional_integer=>{:type=>:integer, :"x-nullable"=>false},
              :optional_integer_or_nil=>{:type=>:integer, :"x-nullable"=>true},
              :required_boolean=>{:type=>:boolean, :"x-nullable"=>false},
              :required_boolean_or_nil=>{:type=>:boolean, :"x-nullable"=>true},
              :optional_boolean=>{:type=>:boolean, :"x-nullable"=>false},
              :optional_boolean_or_nil=>{:type=>:boolean, :"x-nullable"=>true},
              :required_date=>{:type=>:string, :format=>:date, :"x-nullable"=>false},
              :required_date_or_nil=>{:type=>:string, :format=>:date, :"x-nullable"=>true},
              :optional_date=>{:type=>:string, :format=>:date, :"x-nullable"=>false},
              :optional_date_or_nil=>{:type=>:string, :format=>:date, :"x-nullable"=>true},
              :required_date_time=>{:type=>:string, :format=>:datetime, :"x-nullable"=>false},
              :required_date_time_or_nil=>{:type=>:string, :format=>:datetime, :"x-nullable"=>true},
              :optional_date_time=>{:type=>:string, :format=>:datetime, :"x-nullable"=>false},
              :optional_date_time_or_nil=>{:type=>:string, :format=>:datetime, :"x-nullable"=>true},
              :required_time=>{:type=>:string, :format=>:time, :"x-nullable"=>false},
              :required_time_or_nil=>{:type=>:string, :format=>:time, :"x-nullable"=>true},
              :optional_time=>{:type=>:string, :format=>:time, :"x-nullable"=>false},
              :optional_time_or_nil=>{:type=>:string, :format=>:time, :"x-nullable"=>true},
              :hash=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}
              }, :required=>[:required_string, :required_string_or_nil], :"x-nullable"=>false},
              :required_array_of_values=>{:type=>:array, :items=>{:type=>:integer}, :"x-nullable"=>false},
              :required_array_of_values_or_nil=>{:type=>:array, :items=>{:type=>:integer}, :"x-nullable"=>true},
              :optional_array_of_values=>{:type=>:array, :items=>{:type=>:integer}, :"x-nullable"=>false},
              :optional_array_of_values_or_nil=>{:type=>:array, :items=>{:type=>:integer}, :"x-nullable"=>true},
              :required_array_of_nested_dto=>{:type=>:array, :items=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}
              }, :required=>[:required_string, :required_string_or_nil]}, :"x-nullable"=>false},
              :required_array_of_nested_dto_or_nil=>{:type=>:array, :items=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}
              }, :required=>[:required_string, :required_string_or_nil]}, :"x-nullable"=>true},
              :optional_array_of_nested_dto=>{:type=>:array, :items=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}
              }, :required=>[:required_string, :required_string_or_nil]}, :"x-nullable"=>false},
              :optional_array_of_nested_dto_or_nil=>{:type=>:array, :items=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}
              }, :required=>[:required_string, :required_string_or_nil]}, :"x-nullable"=>true},
              :required_nested_dto=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}
              }, :required=>[:required_string, :required_string_or_nil], :"x-nullable"=>false},
              :required_nested_dto_or_nil=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}
              }, :required=>[:required_string, :required_string_or_nil], :"x-nullable"=>true},
              :optional_nested_dto=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}
              }, :required=>[:required_string, :required_string_or_nil], :"x-nullable"=>false},
              :optional_nested_dto_or_nil=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}
              }, :required=>[:required_string, :required_string_or_nil], :"x-nullable"=>true}
          }, :required=>[:required_string, :required_string_or_nil, :required_string_with_enum,
                         :required_string_or_nil_with_enum, :required_integer, :required_integer_or_nil,
                         :required_boolean, :required_boolean_or_nil, :required_date, :required_date_or_nil,
                         :required_date_time, :required_date_time_or_nil, :required_time, :required_time_or_nil,
                         :hash, :required_array_of_values, :required_array_of_values_or_nil, :required_array_of_nested_dto,
                         :required_array_of_nested_dto_or_nil, :required_nested_dto, :required_nested_dto_or_nil]
          }
        end

        before do
          Dry::Swagger.configuration do |config|
            config.nullable_type = :"x-nullable"
          end
        end

        it 'should generate a valid swagger documentation' do
          expect(described_class.new.call(dto)).to match(expected_result)
        end
      end

      context 'when configuration nullable type is set to nullable' do
        let(:expected_result) do
          {
              :type=>:object, :properties=>{
              :required_string=>{:type=>:string, :nullable=>false},
              :required_string_or_nil=>{:type=>:string, :nullable=>true},
              :optional_string=>{:type=>:string, :nullable=>false},
              :optional_string_or_nil=>{:type=>:string, :nullable=>true},
              :required_string_with_enum=>{:type=>:string, :enum=>["test1", "test2"], :nullable=>false},
              :required_string_or_nil_with_enum=>{:type=>:string, :enum=>["test1", "test2", nil], :nullable=>true},
              :optional_string_with_enum=>{:type=>:string, :enum=>["test1", "test2"], :nullable=>false},
              :optional_string_or_nil_with_enum=>{:type=>:string, :enum=>["test1", "test2", nil], :nullable=>true},
              :required_integer=>{:type=>:integer, :nullable=>false},
              :required_integer_or_nil=>{:type=>:integer, :nullable=>true},
              :optional_integer=>{:type=>:integer, :nullable=>false},
              :optional_integer_or_nil=>{:type=>:integer, :nullable=>true},
              :required_boolean=>{:type=>:boolean, :nullable=>false},
              :required_boolean_or_nil=>{:type=>:boolean, :nullable=>true},
              :optional_boolean=>{:type=>:boolean, :nullable=>false},
              :optional_boolean_or_nil=>{:type=>:boolean, :nullable=>true},
              :required_date=>{:type=>:string, :format=>:date, :nullable=>false},
              :required_date_or_nil=>{:type=>:string, :format=>:date, :nullable=>true},
              :optional_date=>{:type=>:string, :format=>:date, :nullable=>false},
              :optional_date_or_nil=>{:type=>:string, :format=>:date, :nullable=>true},
              :required_date_time=>{:type=>:string, :format=>:datetime, :nullable=>false},
              :required_date_time_or_nil=>{:type=>:string, :format=>:datetime, :nullable=>true},
              :optional_date_time=>{:type=>:string, :format=>:datetime, :nullable=>false},
              :optional_date_time_or_nil=>{:type=>:string, :format=>:datetime, :nullable=>true},
              :required_time=>{:type=>:string, :format=>:time, :nullable=>false},
              :required_time_or_nil=>{:type=>:string, :format=>:time, :nullable=>true},
              :optional_time=>{:type=>:string, :format=>:time, :nullable=>false},
              :optional_time_or_nil=>{:type=>:string, :format=>:time, :nullable=>true},
              :hash=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}
              }, :required=>[:required_string, :required_string_or_nil], :nullable=>false},
              :required_array_of_values=>{:type=>:array, :items=>{:type=>:integer}, :nullable=>false},
              :required_array_of_values_or_nil=>{:type=>:array, :items=>{:type=>:integer}, :nullable=>true},
              :optional_array_of_values=>{:type=>:array, :items=>{:type=>:integer}, :nullable=>false},
              :optional_array_of_values_or_nil=>{:type=>:array, :items=>{:type=>:integer}, :nullable=>true},
              :required_array_of_nested_dto=>{:type=>:array, :items=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}
              }, :required=>[:required_string, :required_string_or_nil]}, :nullable=>false},
              :required_array_of_nested_dto_or_nil=>{:type=>:array, :items=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}
              }, :required=>[:required_string, :required_string_or_nil]}, :nullable=>true},
              :optional_array_of_nested_dto=>{:type=>:array, :items=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}
              }, :required=>[:required_string, :required_string_or_nil]}, :nullable=>false},
              :optional_array_of_nested_dto_or_nil=>{:type=>:array, :items=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}
              }, :required=>[:required_string, :required_string_or_nil]}, :nullable=>true},
              :required_nested_dto=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}
              }, :required=>[:required_string, :required_string_or_nil], :nullable=>false},
              :required_nested_dto_or_nil=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}
              }, :required=>[:required_string, :required_string_or_nil], :nullable=>true},
              :optional_nested_dto=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}
              }, :required=>[:required_string, :required_string_or_nil], :nullable=>false},
              :optional_nested_dto_or_nil=>{:type=>:object, :properties=>{
                  :required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}
              }, :required=>[:required_string, :required_string_or_nil], :nullable=>true}
          }, :required=>[:required_string, :required_string_or_nil, :required_string_with_enum,
                         :required_string_or_nil_with_enum, :required_integer, :required_integer_or_nil,
                         :required_boolean, :required_boolean_or_nil, :required_date, :required_date_or_nil,
                         :required_date_time, :required_date_time_or_nil, :required_time, :required_time_or_nil,
                         :hash, :required_array_of_values, :required_array_of_values_or_nil, :required_array_of_nested_dto,
                         :required_array_of_nested_dto_or_nil, :required_nested_dto, :required_nested_dto_or_nil]
          }
        end

        before do
          Dry::Swagger.configuration do |config|
            config.nullable_type = :nullable
          end
        end

        it 'should generate a valid swagger documentation' do
          expect(described_class.new.call(dto)).to match(expected_result)
        end
      end
    end
  end
end
