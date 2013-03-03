module Wiki
  def page
    Brubeck.wiki.page name
  end

  def wikitext
    page ? page.formatted_data.html_safe : ''
  end
end