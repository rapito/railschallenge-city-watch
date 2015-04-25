class CreateResponders < ActiveRecord::Migration
  def change
    create_table :responders do |t|
      t.string :emergency_code
      t.string :responder_type
      t.string :name
      t.integer :capacity
      t.boolean :on_duty

      t.timestamps null: false
    end
    add_index :responders, :emergency_code
    add_index :responders, :responder_type
    add_index :responders, :name
  end
end
