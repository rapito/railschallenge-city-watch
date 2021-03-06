class CreateEmergencies < ActiveRecord::Migration
  def change
    create_table :emergencies do |t|
      t.string :code
      t.integer :fire_severity
      t.integer :police_severity
      t.integer :medical_severity
      t.timestamp :resolved_at

      t.timestamps null: false
    end
    add_index :emergencies, :code
  end
end
