class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :screen_name
      t.string :description
      t.string :picture_url
      t.integer :distance

      t.timestamps
    end
  end
end
