# Load variables into ENV namespace in development
if Rails.env.development?
  require 'yaml'
  application_variables = YAML.load(File.read(Rails.root.join('config', 'application.yml')))
  application_variables.each_pair do |key, variable|
    ENV[key] = variable
  end
end
