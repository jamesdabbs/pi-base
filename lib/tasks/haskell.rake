desc 'Migrate production data as needed to support Haskell co-access'
task :haskelize => :environment do
  [Revision, RemoteUser].map &:delete_all

  users = User.all.each_with_object({}) do |u,h|
    h[u.id] = RemoteUser.where(ident: u.email, admin: !!u.admin).first_or_create
  end

  users[4] = users[3] # Sorry Chris

  PaperTrail::Version.find_each do |v|
    begin
      next unless v.object
      object = v.item_type.constantize.find_by_id v.item_id
      next unless object
      user_id = users[v.whodunnit.to_i].id rescue next
      y = YAML.load v.object
      %w(id created_at).each { |f| y.delete f }
      attrs = {
        item_id: v.item_id,
        item_class: v.item_type,
        user_id: user_id,
        created_at: v.created_at,
        body: y.to_json
      }
      rev = Revision.create!(attrs)
    rescue => e
      binding.pry
      raise
    end
  end

  [Space, Property, Trait, Theorem].each do |model|
    q = model == Trait ? {deduced: false} : {}
    model.where(q).find_each do |obj|
      next if Revision.where(item_class: model.name, item_id: obj.id)
      raise "Need to create initial revisions"
    end
  end

  %w(jamesdabbs@gmail.com austinmohr@gmail.com amohr@nebrwesleyan.edu).each do |e|
    RemoteUser.find_by_ident(e).update_attributes admin: true
  end
end
