class CreateTraits < ActiveRecord::Migration
  def change
    create_table :traits do |t|
      t.integer :space_id
      t.integer :property_id
      t.integer :value_id
      t.text :description

      t.index [:space_id]
      t.index [:property_id, :value_id]

      t.timestamps
    end
  end
end
