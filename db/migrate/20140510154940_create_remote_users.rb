class CreateRemoteUsers < ActiveRecord::Migration
  def change
    create_table :remote_users do |t|
      t.string  :ident
      t.string  :password
      t.string  :name
      t.boolean :admin
    end

    add_index :remote_users, :ident

    create_table :emails do |t|
      t.string  :email
      t.integer :user_id
      t.string  :verkey
    end
  end
end
