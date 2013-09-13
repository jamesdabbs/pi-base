When(/^I search for "(.*?)"$/) do |query|
  fill_in 'q', with: query
  click_button 'Search'
end

Then(/^I should see (\d+ results?)$/) do |count|
  results = find '#result-count'
  expect( results.text ).to match /^#{count}$/i
end

Then(/^I should find "(.*?)" in the search results$/) do |name|
  results = find '#definitions'
  expect( results ).to have_link name
end
