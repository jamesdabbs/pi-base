class AddNotNullToDescriptions < ActiveRecord::Migration
  def change
    %w(spaces properties traits theorems).each do |table|
      change_column table, :description, :text, default: ""
    end
  end
end
