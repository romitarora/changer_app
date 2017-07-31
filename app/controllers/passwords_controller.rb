class PasswordsController < Devise::PasswordsController 
   
  protected
    def after_resetting_password_path_for(resource)
      thank_you_path
    end

end