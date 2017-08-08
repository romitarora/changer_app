class Api::V1::PlaysController < ApplicationController
  # skip_before_action :authenticate_user!
  allow_oauth!
  skip_before_action :verify_authenticity_token

  def create
    @play = Play.create(play_params) 
    if @play.save
      render :json => { action: 'play_create',
                              response: 'true',
                              msg: 'Play was created Successfully!',
                              id: @play.id
                              }
    else
      render :json => { action: 'play_create',
                              response: 'false',
                              msg: 'play was not created'
                              }
    end
  end
  def index
    @play = Play.where(user_id: params[:user_id])
    if !@play.blank?
      render :json => { action: 'play_list',
                              response: 'true',
                              msg: 'Play list was get Successfully!',
                              plays: @play
                              }
    else
      render :json => { action: 'play_list',
                              response: 'false',
                              msg: 'Play list was not get'
                              }
    end
  end


  def update
    @play = Play.find(params[:id])
    if @play.update(play_params)
      render :json => { action: 'play_update',
                              response: 'true',
                              msg: 'Play was updated Successfully!',
                              plays: @play
                              }
    else
      render :json => { action: 'play_update',
                              response: 'false',
                              msg: 'Play was not updated'
                              }
    end
  end

  def destroy
    begin
    @play = Play.find(params[:id])
    if !@play.blank?
      @play.delete
      render :json => { action: 'play_delete',
                              response: 'true',
                              msg: 'Play was delete Successfully!'
                              }
    else
      render :json => { action: 'play_delete',
                              response: 'false',
                              msg: 'Play list was not delete'
                              }
    end

    rescue Exception => e
      render :json => { action: 'play_delete',
                              response: 'false',
                              msg: 'Play was not available with given id.'
                              }
    end
  end

  private
    def play_params 
      params.require(:play).permit(:user_id, :name, :description, :led_no)
    end
end
