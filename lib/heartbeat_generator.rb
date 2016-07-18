module Scheduler
	class HeartbeatGenerator

		def start_heartbeat
			puts "Starting application heartbeat"
			@scheduler = Rufus::Scheduler.new
			@scheduler.in "10s" do
				reset_heartbeat
			end
		end

		def reset_heartbeat
			puts "Application was restarted, deleting previous incomplete heartbeat"
			begin
				Heartbeat.destroy_all
			ensure
				@scheduler = Rufus::Scheduler.new
				@scheduler.in "10s" do
					on_heartbeat
				end
			end
		end
		
		def on_heartbeat
			begin
				puts "Application heartbeat"
				last_heartbeat=Heartbeat.where("state=? or state=?",Heartbeat::PENDING,Heartbeat::IN_PROGRESS)
				if last_heartbeat.size>0
					Rails.logger.info "Aborting - there is another heartbeat in progress"
				else
					last_heartbeat=Heartbeat.find_by_state(Heartbeat::COMPLETE)
					if last_heartbeat!=nil and last_heartbeat.updated_at>DateTime.now-1.minute
						Rails.logger.info "Aborting - last heartbeat finished less than a minute ago"
					else
						new_heartbeat=Heartbeat.new
						new_heartbeat.state=Heartbeat::PENDING
						new_heartbeat.save
						id=new_heartbeat.id
						Rails.logger.info "Hearbeat ID is #{id}"

						sleep(5.seconds)

						current_heartbeat=Heartbeat.find_by_state(Heartbeat::IN_PROGRESS)
						if current_heartbeat!=nil
							Rails.logger.info "Aborting - there is another heartbeat in progress"
						else
							pending_hearbeat=Heartbeat.where("state=?",Heartbeat::PENDING).order("created_at ASC").first
							if pending_hearbeat.id==id
								Rails.logger.info "I was selected to execute the hearbeat"
								pending_hearbeat.state=Heartbeat::IN_PROGRESS
								pending_hearbeat.save

								send_heartbeat

								in_progress_hearbeat=Heartbeat.where("state=?",Heartbeat::IN_PROGRESS).order("created_at ASC").first
								in_progress_hearbeat.state=Heartbeat::COMPLETE
								in_progress_hearbeat.save

								if last_heartbeat!=nil
									last_heartbeat.destroy
								end
							else
								Rails.logger.info "Another node was selected to execute the heartbeat - aborting"
								Heartbeat.find(id).destroy
							end
						end
					end
				end
			ensure
				@scheduler.in "1m" do
					on_heartbeat
				end
			end
		end

		def send_heartbeat
			receivers=get_heartbeat_receivers
			receivers.each do |receiver|
				begin
					length=GC.stat[:heap_length]
					mbs=(length*(2<<13)).to_f/(2<<19)
					Rails.logger.info "Currently using memory: #{mbs}MB"
					receiver.on_heartbeat(tenant)
				rescue Exception => e
					puts "rescued #{e}"
					puts e.backtrace.inspect
				end
			end
		end
		
		def get_heartbeat_receivers
			result=Array.new
			return result
		end

	end
end