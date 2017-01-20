require 'serverspec'
require 'docker'

RSpec.configure do |config|
  set :backend, :docker
  set :docker_container, ENV['KITCHEN_CONTAINER_ID']
  config.color = true
  config.tty = true
end
