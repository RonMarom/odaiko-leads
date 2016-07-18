class AppEvent < ActiveRecord::Base
	SCHEDULED=1
  	SUCCEEDED=2
  	FAILED=3
  	CANCELLED=4
  	HELD_OFF=5
end
