class UpdateFormulaJson < ActiveRecord::Migration
  def up
    Theorem.find_each do |t|
      t.update_column :antecedent, rh(t[:antecedent]).to_json
      t.update_column :consequent, rh(t[:consequent]).to_json
    end
  end

  def rh f
    h = f.as_json.with_indifferent_access
    case h[:_type].to_sym
    when :atom
      { h[:property] => h[:value] }
    when :conjunction
      { and: h[:subformulae].map { |sf| rh sf } }
    when :disjunction
      { or: h[:subformulae].map { |sf| rh sf } }
    else
      raise "Unrecognized type: #{h}"
    end
  end

  def down
    raise NotImplementedError
  end
end
