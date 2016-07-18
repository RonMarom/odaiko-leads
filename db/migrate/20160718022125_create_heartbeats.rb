class CreateHeartbeats < ActiveRecord::Migration
  def change
    create_table :heartbeats do |t|
      t.integer :state

      t.timestamps
    end
  end
end
