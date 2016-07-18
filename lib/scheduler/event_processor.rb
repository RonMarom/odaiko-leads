module Scheduler

  class EventProcessor

    def on_heartbeat
      events=AppEvent.where("state=?",AppEvent::SCHEDULED).order("schedule_time ASC")
      events.each do |event|
        ActiveRecord::Base.transaction do
          begin
            if event.state==AppEvent::SCHEDULED and event.schedule_time<=DateTime.now
              Rails.logger.info "Time to execute event #{event.inspect}"
              execute_event(event)
              event.state=AppEvent::SUCCEEDED
              event.save
            end
          rescue Exception => e  
            Rails.logger.info "Failed to execute event #{event.inspect}"
            event.state=AppEvent::FAILED
            event.message=e.message
            event.stack_trace=e.backtrace.inspect
            event.save
          
            puts "rescued #{e}"
            puts e.backtrace.inspect  
          end
        end    
      end
    end

    def execute_event(event)
      
    end

  end
end