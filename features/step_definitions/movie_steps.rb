# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  movies_table.hashes.each do |movie|
    new_movie = Movie.new
    new_movie.title = movie[:title]
    new_movie.rating = movie[:rating]
    new_movie.release_date = movie[:release_date]
    new_movie.save!
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  o1 = page.html =~ /#{Regexp.quote(e1)}/
  o2 = page.html =~ /#{Regexp.quote(e2)}/
  flunk "Unsorted" unless o1 < o2
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/, /).each do |rating|
    step "I #{uncheck}check \"ratings_#{rating}\""
  end
end

Then /^I should see all of the movies$/ do
  # number of rows in table, including header, should be one
  # more than the number of movies in the database
  num_rows = page.html.scan(/(?=<tr>)/).length - 1
  num_movies = Movie.find(:all).length
  print "rows: #{num_rows}; movies: #{num_movies}\n"
  flunk "not all movies" unless num_movies == num_rows
end
