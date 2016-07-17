class PeopleController < ApplicationController
  def new
  end

  def create
  	screen_name=params[:person][:screen_name]
  	if not(screen_name.start_with?("@"))
  		screen_name="@"+screen_name
  	end

  	config = {
  		consumer_key:"G7mn0LPTaEyHPngmmErA",
  		consumer_secret: "nL3PI9g9gvsREuxDowMP6AsuQjcK3UFGZtjKFccl8O0"
  	}

  	client=Twitter::Client.new(config)

  	twitter_user=client.user(screen_name)

  	person=Person.new
  	person.name=twitter_user.name
  	person.screen_name=screen_name
  	person.description=twitter_user.description
  	person.picture_url=twitter_user.profile_image_url
  	person.distance=0
  	person.save
  end
end
