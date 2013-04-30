class Assumption < ActiveRecord::Base
  belongs_to :proof
  belongs_to :trait
end
