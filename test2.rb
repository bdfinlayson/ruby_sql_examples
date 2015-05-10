require 'sqlite3'

DIRECTORY = "test"
Dir.mkdir(DIRECTORY) unless File.exist?(DIRECTORY)

DBNAME = "#{DIRECTORY}/test.sqlite"

DB = SQLite3::Database.new( DBNAME )

DB.execute("drop table if exists rooms")

DB.execute("create table rooms(id integer primary key autoincrement, room TEXT, description TEXT, next_to INTEGER)")

DB.execute("insert into rooms(room, description) values ('living room', 'A quiet place to read. You see a fireplace in one corner.')")

rooms = DB.execute("select * from rooms").flatten

puts "\n\nYou created a #{rooms[1]} with the description of: #{rooms[2]}\n\n"

#puts "You created a #{rooms['room']} with the description of: #{rooms['description']}"

puts "\n\nPlease add another room\n\n"

room = gets.chomp

DB.execute("insert into rooms (room) values ('#{room}')")

rooms = DB.execute("select room from rooms where room like ?", "#{room}").flatten

puts "\n\nYou created a #{rooms[0]}\n\n"

puts "\n\nPlease add a description to your #{room}\n\n"

description = gets.chomp

DB.execute("update rooms set description = '#{description}' where room = '#{room}'")

description = DB.execute("select description from rooms where room like ?", "#{room}").flatten

puts "\n\nYou created a description for #{room}. It reads #{description[0]}.\n\n"

rooms = DB.execute("select room from rooms").flatten

rooms = rooms.join(', ')

puts "\n\nWhat is the #{room} next to? You can choose from #{rooms}\n\n"

choice = gets.chomp

if rooms.match(choice)
  relation = DB.execute("select id from rooms where room like ?", "#{choice}").flatten
  DB.execute("update rooms set next_to = '#{relation[0]}' where room = '#{room}'")
  puts "\n\nGreat! #{room} is now associated with #{choice}\n\n"
else
  puts "\n\nSorry, #{choice} is not something I recognize\n\n."
end

  
