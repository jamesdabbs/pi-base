class AddFieldsToTheorem < ActiveRecord::Migration
  def change
    add_column :theorems, :antecedent, :string
    add_column :theorems, :consequent, :string
    remove_column :theorems, :formula, :string
  end
end
