module ApplicationHelper
  def bootstrap_will_paginate list
     will_paginate list, renderer: BootstrapPagination::Rails
  end
  
  def markdown text
    # Ugh ...
    Markdown.render(text.gsub '\\', '\\\\\\\\').html_safe
  end
end
