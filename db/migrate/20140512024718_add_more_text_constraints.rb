class AddMoreTextConstraints < ActiveRecord::Migration
  def change
    change_column :remote_users, :admin, :boolean, default: false

    {
      emails: {
        email: :string,
        verkey: :string
      },
      properties: {
        name: :string
      },
      remote_users: {
        ident: :string,
        password: :string
      },
      spaces: {
        name: :string
      },
      theorems: {
        antecedent: :string,
        consequent: :string
      },
      users: {
        name: :string
      },
      value_sets: {
        name: :string
      },
      values: {
        name: :string
      }
    }.each do |table, cols|
      cols.each do |column, type|
        change_column table, column, type, default: ""
      end
    end
  end
end
