class AddNotNullToDescriptions < ActiveRecord::Migration
  def change
    %w(spaces properties traits theorems).each do |table|
      change_column table, :description, :text, default: ""
    end

    [Space, Property, Trait, Theorem].each do |klass|
      klass.where(description: nil).update_all("description = ''")
    end
  end
end
