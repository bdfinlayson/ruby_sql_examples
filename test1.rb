require 'rubygems'
require 'sqlite3'

db = SQLite3::Database.new ('sp500-data.sqlite')

db.results_as_hash = true
#db.results_as_hash = false

#results = db.execute("select * from companies where name like 'C%' order by id asc;")

#results.each{|row| puts row.join(',')}

#puts "#{results[0]['name']} is based in #{results[0]['city']}, #{results[0]['state']}"

#results = db.execute("
#select companies.*, closing_price as lastest_closing_price
#from companies
#inner join stock_prices
#on company_id = companies.id
#where date = (select date
#from stock_prices as s2
#order by date
#desc
#limit 1)")
#
#print results

#In the earlier discussion on subqueries, we examined a query that attempted to find the latest stock price per company.
#
#This time, instead of using subqueries, write two SQL queries and combine it with Ruby looping logic. Remember that subqueries can be thought of as "inner queries" to be executed before the query in which they are nested.
#
#Write the Ruby code that will perform the following query without subqueries:
#
#SELECT companies.*,  closing_price AS latest_closing_price
#   FROM companies
#   INNER JOIN stock_prices
#      ON company_id = companies.id
#    WHERE date = (SELECT date FROM stock_prices AS s2 ORDER BY date DESC LIMIT 1 )

inner_results = db.execute("select date from stock_prices as s2 order by date desc limit 1;")

#print inner_results

latest_date = inner_results[0]['date']

#main_results = db.execute("
#select companies.*, closing_price as latest_closing_price
#from companies
#inner join stock_prices
#on company_id = companies.id
#where date = '#{latest_date}'")

#print main_results

# you can filter the results in the ruby loop

#main_results.each{|row| puts "#{row['name']} is in the #{row['sector']} industry and was last priced at $#{row['latest_closing_price']}" if row['latest_closing_price'].to_i > 100}


# or you can filter them in the sql statement

main_results = db.execute("
select companies.*, closing_price as latest_closing_price
from companies
inner join stock_prices
on company_id = companies.id
where date = '#{latest_date}' AND latest_closing_price > 200")

main_results.each do |row|
puts "#{row['name']} had a closing price of $#{row['latest_closing_price']}"
end







