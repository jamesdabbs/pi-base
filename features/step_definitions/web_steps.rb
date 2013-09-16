When /^(?:|I )go to (.+)$/ do |page_name|
   visit path_to(page_name)
end

Then(/^show me the page$/) { save_and_open_page }
Then(/^pry$/)              { binding.pry        }
