class AddDeviseTokenAndDeviseTypeToOproAuthGrants < ActiveRecord::Migration
  def change
  	add_column :opro_auth_grants, :devise_token, :string, :unique=>true
	add_column :opro_auth_grants, :devise_type, :string
  end
end
