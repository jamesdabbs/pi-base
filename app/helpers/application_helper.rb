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
    # FIXME: better XSS protection with spec
    # FIXME: scan the string and escape contextually depending on if we're in math tags
    text = h text
    text.gsub! '_', '\_'
    Markdown.render(text).html_safe
  end

  def typeahead form, klass, opts={}
    opts['autocomplete']  = 'off'
    opts['data-provide']  = 'typeahead'
    opts['data-source'] ||= klass.pluck(:name).to_json
    form.text_field klass.name.downcase, opts
  end

  def example_search str
    link_to str, search_path(q: str)
  end

  def flash_class name
    # Translate rails conventions to bootstrap conventions
    return :success if name == :notice
    return :error   if name == :alert
    return name
  end

  def icon name
    "<i class='icon-#{name}'></i>".html_safe
  end

  def word_diff version
    # FIXME: what about name changes?
    from, to = version.changeset[:description].map { |s| h(s) }
    Differ.diff_by_word(to, from).format_as(:html).html_safe
  rescue
    version.reify.description rescue nil
  end
end
