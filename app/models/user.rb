class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # Intentionally disabled (for now):
  # :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
end
