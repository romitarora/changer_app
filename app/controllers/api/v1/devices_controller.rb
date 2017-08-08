class Api::V1::DevicesController < ApplicationController
  # skip_before_action :authenticate_user!
  allow_oauth!
  skip_before_action :verify_authenticity_token

  def create
    @device = Device.create(device_params) 
    if @device.save
      render :json => { action: 'device_create',
                              response: 'true',
                              msg: 'Device was created Successfully!',
                              id: @device.id
                              }
    else
      render :json => { action: 'device_create',
                              response: 'false',
                              msg: 'Device was not created'
                              }
    end
  end
  def index
    @device = Device.where(user_id: params[:user_id])
    if !@device.blank?
      render :json => { action: 'device_list',
                              response: 'true',
                              msg: 'Device list was get Successfully!',
                              devices: @device
                              }
    else
      render :json => { action: 'device_list',
                              response: 'false',
                              msg: 'Device list was not get'
                              }
    end
  end


  def update
    @device = Device.find(params[:id])
    if @device.update(device_params)
      render :json => { action: 'device_update',
                              response: 'true',
                              msg: 'Device was updated Successfully!',
                              devices: @device
                              }
    else
      render :json => { action: 'device_update',
                              response: 'false',
                              msg: 'Device was not updated'
                              }
    end
  end

  def destroy
    begin
    @device = Device.find(params[:id])
    if !@device.blank?
      @device.delete
      render :json => { action: 'device_delete',
                              response: 'true',
                              msg: 'Device was delete Successfully!'
                              }
    else
      render :json => { action: 'device_delete',
                              response: 'false',
                              msg: 'Device list was not delete'
                              }
    end

    rescue Exception => e
      render :json => { action: 'device_delete',
                              response: 'false',
                              msg: 'Device was not available with given id.'
                              }
    end
  end

  private
    def device_params 
      params.require(:device).permit(:user_id, :ble_address, :name, :is_active)
    end
end
