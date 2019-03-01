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
total_cards = 370
card_list = []

# Update Card List - This will NOT include Mavericks
puts "Updating Card List..."
until card_list.length >= total_cards
  uri = URI("https://www.keyforgegame.com/api/decks/?page=#{page_number}&page_size=#{page_size}&search=&links=cards")
  response = Net::HTTP.get(URI(uri))
  json = JSON.parse(response)
  cards = json["_linked"]["cards"]
  cards.each do |card|
    unless card["is_maverick"] == true
      unless card_list.any? { |c| c["id"] == card["id"] }
        card_list << card
      end
    end
  end
  puts "#{page_number}/#{page_limit} - Cards: #{card_list.length}"
  page_number = (page_number + 1)
end

card_list.flatten!
File.open("cards.json","w") do |f|
  f.write(card_list.to_json)
end
puts "Card List Updated Successfully."
puts "Update Complete."