def find_result name, results
  expect( results ).to have_link name
end

When(/^I search for "(.*?)"$/) do |query|
  fill_in 'q', with: query
  click_button 'Search'
end

Then(/^I should see (\d+ results?)(.*)$/) do |count, expectations|
  results = find '#result-count'
  expect( results.text ).to match /^#{count}$/i

  expectations.scan(/"(.*?)"/).each do |name|
    expect( results ).to have_link name[1 .. -2]
  end
end
