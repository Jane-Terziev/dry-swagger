require 'dry/swagger'
require 'rails'

module Dry
  module Swagger
    class Railtie < Rails::Railtie
      railtie_name :dry-swagger

      rake_tasks do
        path = File.expand_path(__dir__)
        Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
      end
    end
  end
end
