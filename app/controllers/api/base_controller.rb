module Api
  class BaseController < ApplicationController
  	
   allow_oauth!
 
    # before_filter :authenticate_user!

    
    respond_to :json

     private

    def json_oauth_request?
      oauth? && request.format.json?
    end
  end
end
