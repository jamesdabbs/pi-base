class CreateProofTraits < ActiveRecord::Migration
  def change
    create_table :proof_traits do |t|
      t.integer :proof_id
      t.integer :trait_id

      t.timestamps
    end
  end
end
