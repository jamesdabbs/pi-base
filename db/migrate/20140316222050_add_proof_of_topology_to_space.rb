class AddProofOfTopologyToSpace < ActiveRecord::Migration
  def change
    add_column :spaces, :proof_of_topology, :text
  end
end
