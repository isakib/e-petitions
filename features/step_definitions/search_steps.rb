When /^I search for "([^"]*)" petitions with "([^"]*)"$/ do |state, term|
  visit search_path(:state => state, :q => term)
end

When /^I search for "([^"]*)" petitions with "([^"]*)" ordered by "([^"]*)"$/ do |state, term, order_field|
  order_array = order_field.split(' ')
  visit search_path(:state => state, :q => term, :sort => order_array[0], :order => order_array[1])
end

When /^I search for "([^"]*)"$/ do |query|
  visit home_path
  fill_in :search, :with => query
  click_link_or_button "Search"
end

When /^sunspot is re\-indexed$/ do
  Petition.all.each {|p| p.index! }
end

Then /^I should not be able to search via free text$/ do
  page.should have_no_css("form[action=search]")
end

Then /^I should not be able to search via department$/ do
  page.should have_no_css("a", :text => "Search by department")
end

Then /^I should see an? "([^"]*)" petition count of (\d+)$/ do |state, count|
  page.should have_css(%{#petition_state_tabs li:contains("#{state.capitalize}")}, :text => count.to_s)
end

Then /^the search results table should have the caption [\/"]([^\/]+)[\/"]$/ do |summary_text|
  page.should have_xpath("//*[contains(@class, 'petition_list')]//table/caption[text()='#{summary_text}']")
end
