class Api::V1::UsersController < Api::BaseController
  
  skip_before_action :verify_authenticity_token
  # allow_oauth!   :except => [:create]
  skip_before_action :authenticate_user!, :only => [:create]
  def create
    puts user_params[:email]
    @u = User.where(email: user_params[:email]).first
    if @u.blank?
      @user = User.create(user_params) 
      if @user.save
        Opro::Oauth::ClientApp.create_with_user_and_name(@user, @user.first_name+ @user.id.to_s)
        render :json => { action: 'register',
                                response: 'true',
                                msg: 'Registed Successfully!',
                                user_id: @user.id
                                }
      else
        render :json => { action: 'register',
                                response: 'false',
                                msg: @user.errors.messages
                                }
      end
        
    else
      render :json => { action: 'register',
                            response: 'false',
                            msg: "email has already been taken"
                            }
    end
  end

  def update
    # if User.where(:email => params[:user][:email]).exists?
    #   render :json => { action: 'register',
    #                       response: 'false',
    #                       msg: "email has already been taken"
    #                       }
    # else
      @user = User.find(params[:id]) 
      if @user.update(user_params)
        render :json => { action: 'user_update',
                                response: 'true',
                                msg: 'profile updated Successfully!',
                                user: @user
                                }
      else
        render :json => { action: 'user_updatew',
                                response: 'false',
                                msg: @user.errors.messages[:email][0]
                                }
      end
    # end
  end

  def logout
    @token = Opro::Oauth::AuthGrant.where(access_token: params[:access_token])
    if !@token.blank?
      @token.destroy_all
      respond_to do |format|
        format.json{ render :json => { action: 'logout',
                                      response: 'true',
                                      msg: 'logout Successfully '} }
      end
    else
      respond_to do |format|
        format.json{ render :json => { action: 'logout',
                        response: 'false',
                        msg: 'wrong access_token'}}
      end
    end
  end

  private
    def user_params 
      params.require(:user).permit(:first_name,:last_name, :password, :email,:device_token,:device_type)
    end
end
