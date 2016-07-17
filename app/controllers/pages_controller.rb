class PagesController < ApplicationController
  
  def main
    @logged_in=SocialAccount.all.size>0
    
    respond_to do |format|
      format.html 
      format.json
      format.js
    end
  end
  
end
