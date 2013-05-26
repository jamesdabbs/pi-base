class AddForeignKeys < ActiveRecord::Migration
  def constraints
    {
      assumptions: [:proofs, :traits],
      proofs: [:traits, :theorems],
      properties: [:value_sets],
      theorem_properties: [:theorems, :properties],
      traits: [:spaces, :properties, :values],
      values: [:value_sets]
    }
  end

  def up
    constraints.each do |table, others|
      others.each do |o| 
        name = "#{table}_#{o}_fk"
        add_foreign_key table, o, name: name
      end
    end
  end

  def down
    constraints.each do |table, others|
      others.each do |o| 
        name = "#{table}_#{o}_fk"
        remove_foreign_key table, name: name
      end
    end
  end
end
