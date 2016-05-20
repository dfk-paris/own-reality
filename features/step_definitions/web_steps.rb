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

Then(/^I should (not )?see "(.*?)" within "(.*?)"$/) do |negator, arg1, arg2|
  within arg2 do
    if negator == 'not '
      expect(page).to have_no_content(arg1)
    else
      expect(page).to have_content(arg1)
    end
  end
end

Given(/^I click "([^"]*)" within "([^"]*)"$/) do |text, scope_selector|
  within scope_selector do
    find('a', text: text).click
  end
end

Then(/^I should see (\d+) search results$/) do |amount|
  expect(page).to have_css('or-list-item', count: amount.to_i)
end

When(/^I click on chronology item "(.*?)"$/) do |arg1|
  find(:css, "div.vis-item[data-id='#{arg1}']").click
end

Given(/^I debug$/) do
  binding.pry
end

Given(/^I select language "([^"]*)"$/) do |lang|
  find('or-language-selector select').select(lang)
end

When(/^I click facet "([^"]*)"$/) do |facet|
  step "I click \"#{facet}\" within \"or-clustered-facets\""
end

Then(/^I should (not )?see "([^"]*)" within the search filters$/) do |negator, facet|
  step "I should #{negator}see \"#{facet}\" within \"or-clustered-facets .or-selected\""
end

Then(/^I should (not )?see the facet "([^"]*)"$/) do |negator, facet|
  step "I should #{negator}see \"#{facet}\" within \"or-clustered-facets .or-buckets\""
end

Then(/^there should be "([^"]*)" results$/) do |arg1|
  amount_found = find('or-results .controls > .current').text.strip.scan(/\((\d+)\)/).first.first.to_i
  expect(amount_found).to eq(arg1.to_i)
end

When(/^I click the search filter "([^"]*)"$/) do |arg1|
  within 'or-clustered-facets .or-selected' do
    find('.item', text: arg1).click  
  end
end
