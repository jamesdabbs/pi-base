Given(/^an empty search index$/) do
  # Doing a remove by query to drop all the records is noticeably faster than
  # deleting and re-creating the index, but isn't well supported in Tire.
  # See: https://github.com/karmi/tire/issues/90
  Tire::Configuration.client.delete "#{Tire::Configuration.url}/full/_query?q=*:*"
end

Given(/^that the indices have synced$/) do
  Tire.index('full').refresh
end

When(/^I search for "(.*?)"$/) do |query|
  fill_in 'q', with: query
  click_button 'Search'
end

Then(/^I should see (\d+ results?)(.*)$/) do |count, expectations|
  expect( find('#result-count').text ).to match /^#{count}$/i

  expectations.scan /".*?"/ do |name|
    expect( find '#definitions' ).to have_link name[1 .. -2]
  end
end
