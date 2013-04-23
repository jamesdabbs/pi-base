class TheoremProperty < ActiveRecord::Base
  belongs_to :theorem
  belongs_to :property
end
