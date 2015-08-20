Given(/^I am on the front page$/) do
  visit "/"
end

When(/^I am on the "(.*?)" page$/) do |arg1|
  target = case arg1
    when "front" then "/"
    when "chronology" then "/#/chronology"
    else
      raise "target #{arg1.inspect} is not defined"
  end

  visit target
end

Given(/^I follow "(.*?)"$/) do |arg1|
  click_link arg1
end

Then(/^I should see "([^\"]*?)"$/) do |arg1|
  expect(page).to have_content(arg1)
end

Then(/^I should see "(.*?)" within "(.*?)"$/) do |arg1, arg2|
  within arg2 do
    expect(page).to have_content(arg1)
  end
end

Then(/^I should see some search results$/) do
  expect(page).to have_css(".or-source-list-item")
end

When(/^I click on chronology item "(.*?)"$/) do |arg1|
  find(:css, "div.vis-item[data-id='#{arg1}']").click
end