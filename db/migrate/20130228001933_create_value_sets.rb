class CreateValueSets < ActiveRecord::Migration
  def change
    create_table :value_sets do |t|
      t.string :name

      t.timestamps
    end
  end
end
