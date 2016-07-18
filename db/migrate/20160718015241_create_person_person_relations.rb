class CreatePersonPersonRelations < ActiveRecord::Migration
  def change
    create_table :person_person_relations do |t|
      t.integer :left
      t.integer :right
      t.string :essence

      t.timestamps
    end
  end
end
