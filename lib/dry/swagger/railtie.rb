require 'dry/swagger'
require 'rails'

module Dry
  module Swagger
    class Railtie < Rails::Railtie
      railtie_name :"dry-swagger"

      rake_tasks do
        load "dry/swagger/tasks/configuration_generator.rake"
      end
    end
  end
end
