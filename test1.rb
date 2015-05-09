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

#inner_results = db.execute("select date from stock_prices as s2 order by date desc limit 1;")

#print inner_results

#latest_date = inner_results[0]['date']

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

#main_results = db.execute("
#select companies.*, closing_price as latest_closing_price
#from companies
#inner join stock_prices
#on company_id = companies.id
#where date = '#{latest_date}' AND latest_closing_price > 200")
#
#main_results.each do |row|
#puts "#{row['name']} had a closing price of $#{row['latest_closing_price']}"
#end

#this is super slow!!!

#10.times do |i|
#num1 = rand(10..100)
#num2 = rand(150..200)
#
#results = db.execute("
#select companies.*, closing_price
#from companies
#inner join stock_prices
#on company_id = companies.id
#where closing_price between '#{num1}' and '#{num2}'")
#
#puts results[i]['name']
#end

#10.times do
#   x = rand(190) + 10
#   y = x + rand(200-x)
#   res = db.execute("SELECT COUNT(1) from stock_prices WHERE closing_price > ? AND closing_price < ?", x, y)
#   puts "There are #{res[0][0]} records with closing prices between #{x} and #{y}"
#end

#Using an array with placeholders

#The execute method will accept an array as an argument, which it will automatically break apart into individual arguments. So of course, the number of elements in the array must match the number of placeholders:
#
#db.execute("SELECT * from table_x where name = ? AND age = ? and date = ?, ['Dan', 22, '2006-10-31'])
#
#Exercise: Find all company names that begin with a random set of letters
#
#Write a program that:
#
#Generates a random number, from 1 to 10, of random alphabetical letters.
#Executes a query to find all the company names that begin with any of the set of random letters
#Outputs the number of companies that meet the above condition
#Does this operation 10 times
#The main difference between this exercise and the previous one is that you don't know how many placeholders you'll need for the query. You can use string interpolation and Enumerable methods to dynamically generate the placeholders.
#
#Hint: You can generate an array of alphabet letters with this Range:
#
#letters = ('A'..'Z').to_a

#10.times do
#letters = ('A'..'Z').to_a
#num = rand(1..10)
#sample_letters = letters.sample(num)
#sample_letters.each do |letter|
#result = db.execute("
#select count(1)
#from companies
#where name like ?", letter + "%")
#puts "There are #{result[0][0]} with a name that begins with #{letter}" 
#end
#end

LETTERS = ('A'..'Z').to_a

10.times do
   random_letters = LETTERS.shuffle.first(rand(10) + 1)
   q = random_letters.map{"name LIKE ?"}.join(' OR ')
   res = db.execute("SELECT COUNT(1) from companies WHERE #{q}", random_letters.map{|r| "#{r}%"})
   puts "There are #{res[0][0]} companies with names that begin with #{random_letters.sort.join(', ')}"
end
