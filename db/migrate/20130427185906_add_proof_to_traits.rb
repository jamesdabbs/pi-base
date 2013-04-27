class AddProofToTraits < ActiveRecord::Migration
  def change
    add_column :traits, :proof, :string
  end
end
