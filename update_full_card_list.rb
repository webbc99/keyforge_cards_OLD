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
full_card_list = []

# Updates FULL Card List including all registered Mavericks - NOTE: this takes hours to run
# TODO - hook up a DB and create Card objects as it runs
puts "Updating Full Card List..."
until page_number > page_limit
  uri = URI("https://www.keyforgegame.com/api/decks/?page=#{page_number}&page_size=#{page_size}&search=&links=cards")
  response = Net::HTTP.get(URI(uri))
  json = JSON.parse(response)
  cards = json["_linked"]["cards"]
  cards.each do |card|
    unless full_card_list.any? { |c| c["id"] == card["id"] }
      full_card_list << card
    end
  end
  puts "#{page_number}/#{page_limit} - Cards: #{full_card_list.length}"
  page_number = (page_number + 1)
end

full_card_list.flatten!
File.open("full_card_list.json","w") do |f|
  f.write(full_card_list.to_json)
end
puts "Full Card List Updated Successfully."
puts "Update Complete."