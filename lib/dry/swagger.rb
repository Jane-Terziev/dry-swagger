require "dry/swagger/version"
require 'dry/swagger/documentation_generator'
require 'dry/swagger/errors/missing_hash_schema_error'
require 'dry/swagger/errors/missing_type_error'
require 'dry/swagger/config/configuration'
require 'dry/swagger/config/swagger_configuration'
require 'i18n'
require 'dry/swagger/railtie' if defined?(Rails)

module Dry
  module Swagger
    ::I18n.load_path << Dir[File.expand_path("config/locales") + "/*.yml"] unless defined?(Rails)
  end
end
