require 'fileutils'

namespace 'dry-swagger' do
  desc 'Create a configuration file for Struct and Contract'
  task :create_configuration_file do
    FileUtils.mkdir_p "#{ Dir.pwd }/config/initializers/"
    File.open("#{ Dir.pwd }/config/initializers/dry-swagger.rb", "w") { |file|
file.puts 'Dry::Swagger::Config::StructConfiguration.configuration do |config|
  config.enable_required_validation = true
  config.enable_nullable_validation = true
  config.enable_enums = true
  config.enable_descriptions = true
  config.nullable_type = :"x-nullable" # or :nullable
end

Dry::Swagger::Config::ContractConfiguration.configuration do |config|
  config.enable_required_validation = true
  config.enable_nullable_validation = true
  config.enable_enums = true
  config.enable_descriptions = true
  config.nullable_type = :"x-nullable" # or :nullable
end'
    }
  end

  desc 'Create a YAML file for Contract swagger field descriptions'
  task :create_contract_descriptions_yaml do
    FileUtils.mkdir_p "#{ Dir.pwd }/config/locales/"
    File.open("#{ Dir.pwd }/config/locales/dry-swagger.yml", "w") { |file|
file.puts 'en:
  contract:
    descriptions:
      eql?: "Must be equal to %{value}"
      max_size?: "Maximum size: %{value}"
      min_size?: "Minimum size: %{value}"
      gteq?: "Greater than or equal to %{value}"
      gt?: "Greater than %{value}"
      lt?: "Lower than %{value}"
      lteq?: "Lower than or equal to %{value}"
'
    }
  end

  desc 'Creates configuration files'
  task :install do
    Rake::Task['dry-swagger:create_configuration_file'].execute
    Rake::Task['dry-swagger:create_contract_descriptions_yaml'].execute
  end
end