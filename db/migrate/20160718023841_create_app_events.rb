class CreateAppEvents < ActiveRecord::Migration
  def change
    create_table :app_events do |t|
      t.integer :person_id
      t.string :message
      t.text :stack_trace
      t.integer :event_type
      t.datetime :schedule_time
      t.integer :retry_number

      t.timestamps
    end
  end
end
