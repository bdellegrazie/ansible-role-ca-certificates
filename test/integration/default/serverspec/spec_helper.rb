require 'serverspec'
require 'net/ssh'

RSpec.configure do |config|
  set :backend, :ssh
  set :request_pty, true
  set :ssh_options, {
    host_name: ENV['KITCHEN_HOSTNAME'],
    user: ENV['KITCHEN_USERNAME'],
    keys: [ ENV['KITCHEN_SSH_KEY'] ],
    port: ENV['KITCHEN_PORT'],
    keys_only: true,
    paranoid: false
  }
end
