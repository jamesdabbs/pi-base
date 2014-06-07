[Proof, Assumption, Supporter].each &:delete_all
Trait.deduced.delete_all

puts "Now run:"
puts "  ROLLBAR_ACCESS_TOKEN=\"\" yesod --dev devel"
