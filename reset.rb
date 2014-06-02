[Proof, Assumption, Supporter].each &:delete_all
Trait.deduced.delete_all

#Trait.where("space_id != 76").delete_all
#Space.where("id != 76").delete_all

puts "Now run:"
puts "  ROLLBAR_ACCESS_TOKEN=\"\" yesod --dev devel"
