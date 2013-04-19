class CreateTheorems < ActiveRecord::Migration
  def change
    create_table :theorems do |t|
      t.string :formula
      t.text :description

      t.timestamps
    end
  end
end
