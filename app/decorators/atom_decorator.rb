class AtomDecorator < Draper::Decorator
  delegate_all

  def linked_name
    case value
    when Value.true
      h.link_to property.name, property
    when Value.false
      h.link_to "¬ #{property.name}", property
    else
      "#{h.link_to property, property} = #{h.link_to value, value}"
    end
  end
end