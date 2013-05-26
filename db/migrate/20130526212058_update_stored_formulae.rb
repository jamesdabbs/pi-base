class UpdateStoredFormulae < ActiveRecord::Migration
  def change
    Theorem.all.each do |obj|
      obj.antecedent = Formula.load obj.antecedent
      obj.consequent = Formula.load obj.consequent
      obj.save validate: false
    end
  end
end
