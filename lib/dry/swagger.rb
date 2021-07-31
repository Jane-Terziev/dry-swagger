require "dry/swagger/version"
require "dry/swagger/contract_parser"
require "dry/swagger/struct_parser"
require 'helpers/configuration'

module Dry
  module Swagger
    class Error < StandardError; end

    extend Configuration

    define_setting :struct_enable_required_validation, true
    define_setting :struct_enable_nullable_validation, true
    define_setting :struct_enable_enums, true
    define_setting :struct_enable_descriptions, true

    define_setting :contract_enable_required_validation, true
    define_setting :contract_enable_nullable_validation, true
    define_setting :contract_enable_enums, true
    define_setting :contract_enable_descriptions, true

    define_setting :nullable_type, :"x-nullable"
  end
end
