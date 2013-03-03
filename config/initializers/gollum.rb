require 'gollum/frontend/app'

Brubeck::GollumPath = File.expand_path '../../../wiki', __FILE__

module Brubeck
  def self.wiki
    Gollum::Wiki.new GollumPath
  end
end

Precious::App.set :gollum_path, Brubeck::GollumPath
Precious::App.set :default_markup, :markdown
Precious::App.set :wiki_options, universal_toc: false, mathjax: true

Gollum::Markup.register(:v, "Coq") do |content|
  "<pre>#{CGI::escapeHTML content}</pre>"
end
