class AddMetaToSearchables < ActiveRecord::Migration
  def change
    [:spaces, :properties, :traits, :theorems].each do |table|
      add_column table, :meta, :text
    end
  end
end
