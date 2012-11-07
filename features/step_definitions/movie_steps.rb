# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  
  Movie.destroy_all
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create( movie )
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  reg = "#{Regexp.escape(e1)}.*#{Regexp.escape(e2)}"
  if page.body.respond_to? :should
    page.body.should =~ /#{reg}/m
  else
    assert_match( /#{reg}/m, page.body )
  end


  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |rating|
    if 'un' == uncheck
      uncheck( "ratings_" + rating )
    else
      check( "ratings_" + rating )
    end
  end
end
Then /^(?:|I )should see all of the movies$/ do
  movie_table_rows = page.all(:xpath, '//table[@id="movies"]/tbody/tr')
  rows = movie_table_rows.count
  value = Movie.all.count
  if rows.respond_to? :should
    rows.should == value
  else
    assert rows == value 
  end
end

# 
# Make sure that the director of one movie is another one 
Then /^the director of "(.*)" should be "(.*)"/ do |title, director|
  movie_table_rows = page.all(:xpath, '//table[@id="movies"]/tbody/tr')
  reg = "#{Regexp.escape(title)}.*#{Regexp.escape(director)}"
  for row in movie_table_rows
    if row.respond_to? :should
      row.should =~ /#{reg}/i
    else
      assert_match( /#{reg}/i, row )
    end
  end
end
