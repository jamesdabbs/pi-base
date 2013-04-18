module ApplicationHelper
  def markdown text
    Markdown.render(text).html_safe
  end
end
