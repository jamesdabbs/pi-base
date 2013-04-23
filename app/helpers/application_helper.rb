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

  def typeahead form, klass, opts={}
    opts['autocomplete'] = 'off'
    opts['data-provide'] = 'typeahead'
    opts['data-source']  = klass.pluck(:name).to_json
    form.text_field klass.name.downcase, opts
  end
end
