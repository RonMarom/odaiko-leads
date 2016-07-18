class AddStateToAppEvents < ActiveRecord::Migration
  def change
    add_column :app_events, :state, :integer
  end
end
