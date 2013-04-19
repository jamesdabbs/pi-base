module ApplicationHelper
  def onload
    content_for :onload do
      yield
    end
  end

  def bootstrap_will_paginate list
     will_paginate list, renderer: BootstrapPagination::Rails
  end
  
  def markdown text
    # Ugh ...
    Markdown.render(text.gsub '\\', '\\\\\\\\').html_safe
  end
end
