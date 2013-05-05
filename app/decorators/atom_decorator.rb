class AtomDecorator < Draper::Decorator
  delegate_all

  def linked_name
    case value
    when Value::True
      h.link_to property.name, property
    when Value::False
      h.link_to "¬ #{property.name}", property
    else
      "#{h.link_to property, property} = #{h.link_to value, value}"
    end
  end
end