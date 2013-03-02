require 'gollum/frontend/app'

gollum_path = File.expand_path '../../../wiki', __FILE__

Precious::App.set :gollum_path, gollum_path
Precious::App.set :default_markup, :markdown
Precious::App.set :wiki_options, universal_toc: false
