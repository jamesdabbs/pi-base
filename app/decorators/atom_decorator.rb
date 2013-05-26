class AtomDecorator < Draper::Decorator
  delegate_all

  def linked_name
    safe_name = h.h property.name
    case value
    when Value.true
      h.link_to safe_name, property
    when Value.false
      h.link_to "¬ #{safe_name}", property
    else
      "#{h.link_to safe_name, property} = #{h.link_to value, value}"
    end.html_safe
  end
end