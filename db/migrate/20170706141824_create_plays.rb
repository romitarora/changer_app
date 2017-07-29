class CreatePlays < ActiveRecord::Migration
  def change
    create_table :plays do |t|
    	t.references :user
    	t.string    :name
      t.string    :description
      t.string   :led_no
      t.timestamps null: false
    end
  end
end
