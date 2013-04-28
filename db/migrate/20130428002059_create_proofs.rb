class CreateProofs < ActiveRecord::Migration
  def change
    create_table :proofs do |t|
      t.integer :trait_id
      t.integer :theorem_id
      t.integer :theorem_index

      t.timestamps
    end
  end
end
