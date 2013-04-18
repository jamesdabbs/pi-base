module ApplicationHelper
  def markdown text
    # Ugh ...
    Markdown.render(text.gsub '\\', '\\\\\\\\').html_safe
  end
end
