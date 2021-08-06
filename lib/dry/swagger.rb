require "dry/swagger/version"
require "dry/swagger/contract_parser"
require "dry/swagger/struct_parser"
require 'dry/swagger/documentation_generator'
require 'dry/swagger/errors/missing_hash_schema_error'
require 'dry/swagger/errors/missing_type_error'
require 'dry/swagger/config/configuration'
require 'dry/swagger/config/contract_configuration'
require 'dry/swagger/config/struct_configuration'
require 'i18n'
require 'dry/swagger/railtie' if defined?(Rails)

module Dry
  module Swagger
    ::I18n.load_path << Dir[File.expand_path("config/locales") + "/*.yml"]
  end
end
