module ApplicationHelper
  def onload
    content_for :onload do
      yield
    end
  end

  def bootstrap_will_paginate list, opts={}
    opts[:renderer] = BootstrapPagination::Rails
    will_paginate list, opts
  end
  
  def markdown text
    # Ugh ...
    Markdown.render(text.gsub '\\', '\\\\\\\\').html_safe
  end
end
