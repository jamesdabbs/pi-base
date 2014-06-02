class Revision < ActiveRecord::Base
  belongs_to :user, class: RemoteUser
  belongs_to :parent, class: Revision
end
