desc 'Create RemoteUser entries for each User'
task :remote_users => :environment do
  User.find_each do |u|
    RemoteUser.where(ident: u.email).create_with(
      name:  u.name,
      admin: !!u.admin
    ).first_or_create
  end
end
