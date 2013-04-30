class Supporter < ActiveRecord::Base
  belongs_to :assumed, class_name: 'Trait'
  belongs_to :implied, class_name: 'Trait'
end
