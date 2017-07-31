class Notifier < ApplicationMailer

	def password_reset_instructions(user,pass)
	    # @user  = user
	    # @new_pass = pass
	    # headers['return-path'] = "no-reply@advisortlc.com"
	    # email =  user.first_name.capitalize + ' ' + user.last_name.capitalize + ' <' + user.email + '>'
	    # mail(:to => email, :subject =>'Password Reset Instructions')

	     @user  = user
	    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
	    email =  user.first_name.capitalize + ' ' + user.last_name.capitalize + ' <' + user.email + '>'
	    mail(:to => email, :subject =>'Password Reset Instructions')
    end
end
