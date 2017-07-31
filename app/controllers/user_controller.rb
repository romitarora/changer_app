class UserController < ApplicationController
	skip_before_action :verify_authenticity_token
	skip_before_action :authenticate_user!
  def thank_you
  end
end
