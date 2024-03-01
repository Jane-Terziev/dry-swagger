# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dry::Swagger::DocumentationGenerator do
  subject { described_class.new }


  describe "#.generate_documentation(fields)" do
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

          required(:decimal).value(:decimal)
          required(:decimal1).maybe(:decimal)
          required(:decimal2).filled(:decimal)

          optional(:decimal3).value(:decimal)
          optional(:decimal4).maybe(:decimal)
          optional(:decimal5).filled(:decimal)

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
              :decimal=>{:type=>:string, :"x-nullable"=>false, format: :decimal},
              :decimal1=>{:type=>:string, :"x-nullable"=>true, format: :decimal},
              :decimal2=>{:type=>:string, :"x-nullable"=>false, format: :decimal},
              :decimal3=>{:type=>:string, :"x-nullable"=>false, format: :decimal},
              :decimal4=>{:type=>:string, :"x-nullable"=>true, format: :decimal},
              :decimal5=>{:type=>:string, :"x-nullable"=>false, format: :decimal},
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
              :decimal,
              :decimal1,
              :decimal2,
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
          Dry::Swagger::Config::SwaggerConfiguration.configuration do |config|
            config.nullable_type = :"x-nullable"
          end
        end

        it 'should generate a valid swagger documentation' do
          expect(subject.from_validation(test_contract)).to match(expected_result)
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
              :decimal=>{:type=>:string, :nullable=>false, format: :decimal},
              :decimal1=>{:type=>:string, :nullable=>true, format: :decimal},
              :decimal2=>{:type=>:string, :nullable=>false, format: :decimal},
              :decimal3=>{:type=>:string, :nullable=>false, format: :decimal},
              :decimal4=>{:type=>:string, :nullable=>true, format: :decimal},
              :decimal5=>{:type=>:string, :nullable=>false, format: :decimal},
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
              :decimal,
              :decimal1,
              :decimal2,
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
          Dry::Swagger::Config::SwaggerConfiguration.configuration do |config|
            config.nullable_type = :nullable
          end
        end

        it 'should generate a valid swagger documentation' do
          expect(subject.from_validation(test_contract)).to match(expected_result)
        end
      end
    end
  end

  describe "#.generate_documentation(fields)" do
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

        attribute :required_decimal, Dry::Swagger::Types::Decimal
        attribute :required_decimal_or_nil, Dry::Swagger::Types::Decimal.optional
        attribute? :optional_decimal, Dry::Swagger::Types::Decimal
        attribute? :optional_decimal_or_nil, Dry::Swagger::Types::Decimal.optional

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
        attribute :required_array_of_values_or_nil, Dry::Swagger::Types::Array.of(Dry::Swagger::Types::Integer.optional)
        attribute? :optional_array_of_values, Dry::Swagger::Types::Array.of(Dry::Swagger::Types::Integer)
        attribute? :optional_array_of_values_or_nil, Dry::Swagger::Types::Array.of(Dry::Swagger::Types::Integer.optional)

        attribute :required_array_of_nested_dto, Dry::Swagger::Types::Array.of(nested_dto)
        attribute :required_array_of_nested_dto_or_nil, Dry::Swagger::Types::Array.of(nested_dto.optional)
        attribute? :optional_array_of_nested_dto, Dry::Swagger::Types::Array.of(nested_dto)
        attribute? :optional_array_of_nested_dto_or_nil, Dry::Swagger::Types::Array.of(nested_dto.optional)

        attribute :required_nested_dto, nested_dto
        attribute :required_nested_dto_or_nil, nested_dto.optional
        attribute? :optional_nested_dto, nested_dto
        attribute? :optional_nested_dto_or_nil, nested_dto.optional
      end
    end

    context 'when configuration nullable type is set to x-nullable' do
      let(:expected_result) do
        {:type=>:object,
         :properties=>
           {:required_string=>{:type=>:string, :"x-nullable"=>false},
            :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
            :optional_string=>{:type=>:string, :"x-nullable"=>false},
            :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
            :required_string_with_enum=>
              {:type=>:string, :enum=>["test1", "test2"], :"x-nullable"=>false},
            :required_string_or_nil_with_enum=>
              {:type=>:string, :enum=>["test1", "test2", nil], :"x-nullable"=>true},
            :optional_string_with_enum=>
              {:type=>:string, :enum=>["test1", "test2"], :"x-nullable"=>false},
            :optional_string_or_nil_with_enum=>
              {:type=>:string, :enum=>["test1", "test2", nil], :"x-nullable"=>true},
            :required_integer=>{:type=>:integer, :"x-nullable"=>false},
            :required_integer_or_nil=>{:type=>:integer, :"x-nullable"=>true},
            :optional_integer=>{:type=>:integer, :"x-nullable"=>false},
            :optional_integer_or_nil=>{:type=>:integer, :"x-nullable"=>true},
            :required_decimal=>{:type=>:string, :"x-nullable"=>false, format: :decimal},
            :required_decimal_or_nil=>{:type=>:string, :"x-nullable"=>true, format: :decimal},
            :optional_decimal=>{:type=>:string, :"x-nullable"=>false, format: :decimal},
            :optional_decimal_or_nil=>{:type=>:string, :"x-nullable"=>true, format: :decimal},
            :required_boolean=>{:type=>:boolean, :"x-nullable"=>false},
            :required_boolean_or_nil=>{:type=>:boolean, :"x-nullable"=>true},
            :optional_boolean=>{:type=>:boolean, :"x-nullable"=>false},
            :optional_boolean_or_nil=>{:type=>:boolean, :"x-nullable"=>true},
            :required_date=>{:type=>:string, :format=>:date, :"x-nullable"=>false},
            :required_date_or_nil=>{:type=>:string, :format=>:date, :"x-nullable"=>true},
            :optional_date=>{:type=>:string, :format=>:date, :"x-nullable"=>false},
            :optional_date_or_nil=>{:type=>:string, :format=>:date, :"x-nullable"=>true},
            :required_date_time=>{:type=>:string, :format=>:datetime, :"x-nullable"=>false},
            :required_date_time_or_nil=>
              {:type=>:string, :format=>:datetime, :"x-nullable"=>true},
            :optional_date_time=>{:type=>:string, :format=>:datetime, :"x-nullable"=>false},
            :optional_date_time_or_nil=>
              {:type=>:string, :format=>:datetime, :"x-nullable"=>true},
            :required_time=>{:type=>:string, :format=>:time, :"x-nullable"=>false},
            :required_time_or_nil=>{:type=>:string, :format=>:time, :"x-nullable"=>true},
            :optional_time=>{:type=>:string, :format=>:time, :"x-nullable"=>false},
            :optional_time_or_nil=>{:type=>:string, :format=>:time, :"x-nullable"=>true},
            :hash=>
              {:type=>:object,
               :properties=>
                 {:required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}},
               :required=>[:required_string, :required_string_or_nil],
               :"x-nullable"=>false},
            :required_array_of_values=>
              {:type=>:array,
               :items=>{:type=>:integer, :"x-nullable"=>false},
               :"x-nullable"=>false},
            :required_array_of_values_or_nil=>
              {:type=>:array,
               :items=>{:type=>:integer, :"x-nullable"=>true},
               :"x-nullable"=>true},
            :optional_array_of_values=>
              {:type=>:array,
               :items=>{:type=>:integer, :"x-nullable"=>false},
               :"x-nullable"=>false},
            :optional_array_of_values_or_nil=>
              {:type=>:array,
               :items=>{:type=>:integer, :"x-nullable"=>true},
               :"x-nullable"=>true},
            :required_array_of_nested_dto=>
              {:type=>:array,
               :items=>
                 {:type=>:object,
                  :properties=>
                    {:required_string=>{:type=>:string, :"x-nullable"=>false},
                     :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                     :optional_string=>{:type=>:string, :"x-nullable"=>false},
                     :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}},
                  :required=>[:required_string, :required_string_or_nil],
                  :"x-nullable"=>false},
               :"x-nullable"=>false},
            :required_array_of_nested_dto_or_nil=>
              {:type=>:array,
               :items=>
                 {:type=>:object,
                  :properties=>
                    {:required_string=>{:type=>:string, :"x-nullable"=>false},
                     :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                     :optional_string=>{:type=>:string, :"x-nullable"=>false},
                     :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}},
                  :required=>[:required_string, :required_string_or_nil],
                  :"x-nullable"=>true},
               :"x-nullable"=>true},
            :optional_array_of_nested_dto=>
              {:type=>:array,
               :items=>
                 {:type=>:object,
                  :properties=>
                    {:required_string=>{:type=>:string, :"x-nullable"=>false},
                     :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                     :optional_string=>{:type=>:string, :"x-nullable"=>false},
                     :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}},
                  :required=>[:required_string, :required_string_or_nil],
                  :"x-nullable"=>false},
               :"x-nullable"=>false},
            :optional_array_of_nested_dto_or_nil=>
              {:type=>:array,
               :items=>
                 {:type=>:object,
                  :properties=>
                    {:required_string=>{:type=>:string, :"x-nullable"=>false},
                     :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                     :optional_string=>{:type=>:string, :"x-nullable"=>false},
                     :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}},
                  :required=>[:required_string, :required_string_or_nil],
                  :"x-nullable"=>true},
               :"x-nullable"=>true},
            :required_nested_dto=>
              {:type=>:object,
               :properties=>
                 {:required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}},
               :required=>[:required_string, :required_string_or_nil],
               :"x-nullable"=>false},
            :required_nested_dto_or_nil=>
              {:type=>:object,
               :properties=>
                 {:required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}},
               :required=>[:required_string, :required_string_or_nil],
               :"x-nullable"=>true},
            :optional_nested_dto=>
              {:type=>:object,
               :properties=>
                 {:required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}},
               :required=>[:required_string, :required_string_or_nil],
               :"x-nullable"=>false},
            :optional_nested_dto_or_nil=>
              {:type=>:object,
               :properties=>
                 {:required_string=>{:type=>:string, :"x-nullable"=>false},
                  :required_string_or_nil=>{:type=>:string, :"x-nullable"=>true},
                  :optional_string=>{:type=>:string, :"x-nullable"=>false},
                  :optional_string_or_nil=>{:type=>:string, :"x-nullable"=>true}},
               :required=>[:required_string, :required_string_or_nil],
               :"x-nullable"=>true}},
         :required=>
           [:required_string,
            :required_string_or_nil,
            :required_string_with_enum,
            :required_string_or_nil_with_enum,
            :required_integer,
            :required_integer_or_nil,
            :required_decimal,
            :required_decimal_or_nil,
            :required_boolean,
            :required_boolean_or_nil,
            :required_date,
            :required_date_or_nil,
            :required_date_time,
            :required_date_time_or_nil,
            :required_time,
            :required_time_or_nil,
            :hash,
            :required_array_of_values,
            :required_array_of_values_or_nil,
            :required_array_of_nested_dto,
            :required_array_of_nested_dto_or_nil,
            :required_nested_dto,
            :required_nested_dto_or_nil]
        }
      end

      before do
        Dry::Swagger::Config::SwaggerConfiguration.configuration do |config|
          config.nullable_type = :"x-nullable"
        end
      end

      it 'should generate a valid swagger documentation' do
        expect(subject.from_struct(dto)).to match(expected_result)
      end
    end

    context 'when configuration nullable type is set to nullable' do
      let(:expected_result) do
        {:type=>:object,
         :properties=>
           {:required_string=>{:type=>:string, :nullable=>false},
            :required_string_or_nil=>{:type=>:string, :nullable=>true},
            :optional_string=>{:type=>:string, :nullable=>false},
            :optional_string_or_nil=>{:type=>:string, :nullable=>true},
            :required_string_with_enum=>
              {:type=>:string, :enum=>["test1", "test2"], :nullable=>false},
            :required_string_or_nil_with_enum=>
              {:type=>:string, :enum=>["test1", "test2", nil], :nullable=>true},
            :optional_string_with_enum=>
              {:type=>:string, :enum=>["test1", "test2"], :nullable=>false},
            :optional_string_or_nil_with_enum=>
              {:type=>:string, :enum=>["test1", "test2", nil], :nullable=>true},
            :required_integer=>{:type=>:integer, :nullable=>false},
            :required_integer_or_nil=>{:type=>:integer, :nullable=>true},
            :optional_integer=>{:type=>:integer, :nullable=>false},
            :optional_integer_or_nil=>{:type=>:integer, :nullable=>true},
            :required_decimal=>{:type=>:string, :nullable=>false, format: :decimal},
            :required_decimal_or_nil=>{:type=>:string, :nullable=>true, format: :decimal},
            :optional_decimal=>{:type=>:string, :nullable=>false, format: :decimal},
            :optional_decimal_or_nil=>{:type=>:string, :nullable=>true, format: :decimal},
            :required_boolean=>{:type=>:boolean, :nullable=>false},
            :required_boolean_or_nil=>{:type=>:boolean, :nullable=>true},
            :optional_boolean=>{:type=>:boolean, :nullable=>false},
            :optional_boolean_or_nil=>{:type=>:boolean, :nullable=>true},
            :required_date=>{:type=>:string, :format=>:date, :nullable=>false},
            :required_date_or_nil=>{:type=>:string, :format=>:date, :nullable=>true},
            :optional_date=>{:type=>:string, :format=>:date, :nullable=>false},
            :optional_date_or_nil=>{:type=>:string, :format=>:date, :nullable=>true},
            :required_date_time=>{:type=>:string, :format=>:datetime, :nullable=>false},
            :required_date_time_or_nil=>
              {:type=>:string, :format=>:datetime, :nullable=>true},
            :optional_date_time=>{:type=>:string, :format=>:datetime, :nullable=>false},
            :optional_date_time_or_nil=>
              {:type=>:string, :format=>:datetime, :nullable=>true},
            :required_time=>{:type=>:string, :format=>:time, :nullable=>false},
            :required_time_or_nil=>{:type=>:string, :format=>:time, :nullable=>true},
            :optional_time=>{:type=>:string, :format=>:time, :nullable=>false},
            :optional_time_or_nil=>{:type=>:string, :format=>:time, :nullable=>true},
            :hash=>
              {:type=>:object,
               :properties=>
                 {:required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}},
               :required=>[:required_string, :required_string_or_nil],
               :nullable=>false},
            :required_array_of_values=>
              {:type=>:array,
               :items=>{:type=>:integer, :nullable=>false},
               :nullable=>false},
            :required_array_of_values_or_nil=>
              {:type=>:array,
               :items=>{:type=>:integer, :nullable=>true},
               :nullable=>true},
            :optional_array_of_values=>
              {:type=>:array,
               :items=>{:type=>:integer, :nullable=>false},
               :nullable=>false},
            :optional_array_of_values_or_nil=>
              {:type=>:array,
               :items=>{:type=>:integer, :nullable=>true},
               :nullable=>true},
            :required_array_of_nested_dto=>
              {:type=>:array,
               :items=>
                 {:type=>:object,
                  :properties=>
                    {:required_string=>{:type=>:string, :nullable=>false},
                     :required_string_or_nil=>{:type=>:string, :nullable=>true},
                     :optional_string=>{:type=>:string, :nullable=>false},
                     :optional_string_or_nil=>{:type=>:string, :nullable=>true}},
                  :required=>[:required_string, :required_string_or_nil],
                  :nullable=>false},
               :nullable=>false},
            :required_array_of_nested_dto_or_nil=>
              {:type=>:array,
               :items=>
                 {:type=>:object,
                  :properties=>
                    {:required_string=>{:type=>:string, :nullable=>false},
                     :required_string_or_nil=>{:type=>:string, :nullable=>true},
                     :optional_string=>{:type=>:string, :nullable=>false},
                     :optional_string_or_nil=>{:type=>:string, :nullable=>true}},
                  :required=>[:required_string, :required_string_or_nil],
                  :nullable=>true},
               :nullable=>true},
            :optional_array_of_nested_dto=>
              {:type=>:array,
               :items=>
                 {:type=>:object,
                  :properties=>
                    {:required_string=>{:type=>:string, :nullable=>false},
                     :required_string_or_nil=>{:type=>:string, :nullable=>true},
                     :optional_string=>{:type=>:string, :nullable=>false},
                     :optional_string_or_nil=>{:type=>:string, :nullable=>true}},
                  :required=>[:required_string, :required_string_or_nil],
                  :nullable=>false},
               :nullable=>false},
            :optional_array_of_nested_dto_or_nil=>
              {:type=>:array,
               :items=>
                 {:type=>:object,
                  :properties=>
                    {:required_string=>{:type=>:string, :nullable=>false},
                     :required_string_or_nil=>{:type=>:string, :nullable=>true},
                     :optional_string=>{:type=>:string, :nullable=>false},
                     :optional_string_or_nil=>{:type=>:string, :nullable=>true}},
                  :required=>[:required_string, :required_string_or_nil],
                  :nullable=>true},
               :nullable=>true},
            :required_nested_dto=>
              {:type=>:object,
               :properties=>
                 {:required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}},
               :required=>[:required_string, :required_string_or_nil],
               :nullable=>false},
            :required_nested_dto_or_nil=>
              {:type=>:object,
               :properties=>
                 {:required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}},
               :required=>[:required_string, :required_string_or_nil],
               :nullable=>true},
            :optional_nested_dto=>
              {:type=>:object,
               :properties=>
                 {:required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}},
               :required=>[:required_string, :required_string_or_nil],
               :nullable=>false},
            :optional_nested_dto_or_nil=>
              {:type=>:object,
               :properties=>
                 {:required_string=>{:type=>:string, :nullable=>false},
                  :required_string_or_nil=>{:type=>:string, :nullable=>true},
                  :optional_string=>{:type=>:string, :nullable=>false},
                  :optional_string_or_nil=>{:type=>:string, :nullable=>true}},
               :required=>[:required_string, :required_string_or_nil],
               :nullable=>true}},
         :required=>
           [:required_string,
            :required_string_or_nil,
            :required_string_with_enum,
            :required_string_or_nil_with_enum,
            :required_integer,
            :required_integer_or_nil,
            :required_decimal,
            :required_decimal_or_nil,
            :required_boolean,
            :required_boolean_or_nil,
            :required_date,
            :required_date_or_nil,
            :required_date_time,
            :required_date_time_or_nil,
            :required_time,
            :required_time_or_nil,
            :hash,
            :required_array_of_values,
            :required_array_of_values_or_nil,
            :required_array_of_nested_dto,
            :required_array_of_nested_dto_or_nil,
            :required_nested_dto,
            :required_nested_dto_or_nil]
        }
      end

      before do
        Dry::Swagger::Config::SwaggerConfiguration.configuration do |config|
          config.nullable_type = :nullable
        end
      end

      it 'should generate a valid swagger documentation' do
        expect(subject.from_struct(dto)).to match(expected_result)
      end
    end
  end
end
