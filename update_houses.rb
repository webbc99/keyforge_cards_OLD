require 'net/http'
require 'json'
require_relative 'card.rb'

# Get the total number of pages of decks
uri = URI("https://www.keyforgegame.com/api/decks/")
response = Net::HTTP.get(URI(uri))
json = JSON.parse(response)
deck_count = json["count"]

# Set variables
page_number = 1
page_size = 30
page_limit = deck_count / 30
total_houses = 7
houses = []

# Update Houses
puts "Updating Houses..."
until houses.length >= total_houses
  uri = URI("https://www.keyforgegame.com/api/decks/?page=#{page_number}&page_size=#{page_size}&search=&links=cards")
  response = Net::HTTP.get(URI(uri))
  json = JSON.parse(response)
  houses = json["_linked"]["houses"]
  houses.each do |house|
    unless houses.any? { |h| h["id"] == house["id"] }
      houses << house
    end
  end
  puts "#{page_number}/#{page_limit} - Houses: #{houses.length}"
  page_number = (page_number + 1)
end

File.open("houses.json","w") do |f|
  f.write(houses.to_json)
end

puts "Houses Updated Successfully."
puts "Update Complete"

# houses_from_json = JSON.parse(File.read("houses.json"))