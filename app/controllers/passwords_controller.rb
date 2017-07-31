class PasswordsController < Devise::PasswordsController 
   prepend_before_action :require_no_authentication
  # Render the #edit only if coming from a reset password email link
  append_before_action :assert_reset_token_passed, only: :edit
  protected
    def after_resetting_password_path_for(resource)
      thank_you_path
    end

end
