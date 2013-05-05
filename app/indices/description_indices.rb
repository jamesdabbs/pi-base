[:space, :property].each do |klass|
  ThinkingSphinx::Index.define klass, with: :active_record do
    indexes name, description
  end
end

# FIXME: index generated names of traits and theorems, descriptions of *direct* traits and all theorems