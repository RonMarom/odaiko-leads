require 'heartbeat_generator'

Rails.logger.info "Running initializer"
puts "running initializer"

if defined?(Rails::Server)
	Rails.logger.info "In server"
  	Scheduler::HeartbeatGenerator.new.start_heartbeat
else
  	puts 'Not in server'
  	Rails.logger.info "Not in server"
end