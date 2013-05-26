class TheoremDecorator < Draper::Decorator
  delegate_all

  def linked_name
    [antecedent, consequent].map do |formula|
      formula.to_s { |atom| AtomDecorator.new(atom).linked_name }
    end.join ' ⇒ '
  end
end