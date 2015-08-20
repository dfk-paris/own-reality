Given(/^I am on the front page$/) do
  visit "/"
end

Given(/^I follow "(.*?)"$/) do |arg1|
  click_link arg1
end

Then(/^I should see "(.*?)"$/) do |arg1|
  expect(page).to have_content(arg1)
end

Then(/^I should see some search results$/) do
  expect(page).to have_css(".or-source-list-item")
end