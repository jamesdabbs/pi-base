class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.string :name
      t.integer :value_set_id

      t.index :value_set_id
      
      t.timestamps
    end
  end
end
