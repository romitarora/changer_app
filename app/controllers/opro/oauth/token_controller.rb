# This controller is where clients can exchange
# codes and refresh_tokens for access_tokens

class Opro::Oauth::TokenController < OproController
  skip_before_filter :opro_authenticate_user!,    :only => [:create]
  skip_before_filter :verify_authenticity_token,  :only   => [:create]
  skip_before_action :authenticate_user!

  def create
    # Find the client application
    if !params[:device_token].blank?
      @token = Opro::Oauth::AuthGrant.where(devise_token: params[:device_token])
      if !@token.blank?
        @token.destroy_all
      end
      @user=User.where(email: params[:email]).first
      if !@user.blank?    
        application = Opro::Oauth::ClientApp.where(user_id: @user.id).first
         # application = Opro::Oauth::ClientApp.authenticate(params[:client_id], params[:client_secret])
        auth_grant  = auth_grant_for(application, params)
       
        if auth_grant.present?
          auth_grant.refresh!
          render :json => { action: 'login',
                            response: 'true',
                            msg: 'Successfully login',
                            access_token:  auth_grant.access_token,
                            userdetails:
                           { user_id: @user.id, 
                            first_name: @user.first_name,
                            last_name: @user.last_name,
                            email: @user.email}}

        else
          # render_error debug_msg(params, application)
          if params[:password]
           render :json => { action: 'login',
                            response: 'false',
                            msg: 'wrong password',
                            error_code: '99'}
          end
          if params[:refresh_token]
           render :json => { action: 'login',
                            response: 'false',
                            msg: 'wrong refresh token',
                            error_code: '98'}
          end
        end
     else
      render :json => { action: 'login',
                          response: 'false',
                          msg: 'User was not exists.'}
     end
   else
    render :json => { action: 'login',
                        response: 'false',
                        msg: 'please provide device token.'}
   end

  end

  private

  def auth_grant_for(application, params)
    if params[:code]
      Opro::Oauth::AuthGrant.find_by_code_app(params[:code], application)
    elsif params[:refresh_token]
      Opro::Oauth::AuthGrant.find_by_refresh_app(params[:refresh_token], application)
    elsif params[:password].present? || params[:grant_type] == "password"|| params[:grant_type] == "bearer"
      return false unless Opro.password_exchange_enabled?
      return false unless oauth_valid_password_auth?(application.app_id, application.app_secret)
      user       = ::Opro.find_user_for_all_auths!(self, params)
      return false unless user.present?
      auth_grant = Opro::Oauth::AuthGrant.find_or_create_by_user_app(user, application, params[:device_token], params[:devise_type])
      auth_grant.update_permissions if auth_grant.present?
      auth_grant
    end
  end

  # def debug_msg(options, app)
  #   msg = "Could not find a user that belongs to this application"
  #   msg << " based on client_id=#{options[:client_id]} and client_secret=#{options[:client_secret]}" if app.blank?
  #   msg << " & has a refresh_token=#{options[:refresh_token]}" if options[:refresh_token]
  #   msg << " & has been granted a code=#{options[:code]}"      if options[:code]
  #   msg << " using username and password"                      if options[:password]
  #   msg
  # end

  # def render_error(msg)
  #   render :json => {:error => msg }, :status => :unauthorized
  # end

end
