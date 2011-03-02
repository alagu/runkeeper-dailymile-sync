require 'compass'
require 'compass/app_integration/rails'
require "fileutils"

Compass::AppIntegration::Rails.initialize!

FileUtils.mkdir_p(Rails.root.join("tmp", "stylesheets", "compiled"))
Rails.application.middleware.insert_before('Rack::Lock', 'Rack::Static', :root => "tmp/", :urls => ["/stylesheets/compiled"])
