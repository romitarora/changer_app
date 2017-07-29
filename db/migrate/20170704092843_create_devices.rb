class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
    	t.references :user
    	t.string    :name
      t.string    :ble_address
      t.boolean   :is_active
      t.timestamps null: false
    end
  end
end
