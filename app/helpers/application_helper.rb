module ApplicationHelper
  def markdown text
    GitHub::Markdown.render(text).html_safe
  end
end
