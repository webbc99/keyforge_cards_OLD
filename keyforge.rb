require 'net/http'
require 'json'
require_relative 'card.rb'

# Get the JSON from the deck API, by default this has the most recent 10 decks
uri = URI('https://www.keyforgegame.com/api/decks/')
response = Net::HTTP.get(URI(uri))
json = JSON.parse(response)

# To get a random deck, make a request with the page size set to 1 and we select a page number randomly between 1 and the total number of decks
# Finally, save the data node which contains the 1 deck into a random_deck variable which we can use 
deck_count = json["count"]
random_page = rand(deck_count) + 1
response = Net::HTTP.get(URI("#{uri}?page=#{random_page}&page_size=1"))
json = JSON.parse(response)
random_deck = json["data"][0]

# Store deck attributes in variables
deck_name = random_deck["name"]
puts "The Deck of the Day is #{deck_name}"
expansion = random_deck["expansion"] # 341 is Call of the Archons
deck_id = random_deck["id"]
deck_houses = random_deck["_links"]["houses"] # an array of houses the deck has
houses = ["Brobnar", "Dis", "Logos", "Mars", "Untamed", "Sanctum", "Shadows"] # an array of all existing houses
cards = random_deck["cards"] # Cards is an array. We will loop over this and compare the card IDs to the IDs in the cards.json file to get info

# Load the card json - this contains info on every card by ID
file = File.read("cards.json")
card_list = JSON.parse(file)
decklist = []

puts "Decklist:"
cards.each do |card|
  card_data = card_list.find { |c| c["id"] == card }
  puts "#{card_data["house"]}: #{card_data["card_title"]} (#{card_data["card_type"]}, #{card_data["rarity"]})"
  decklist << CardWrapper.card(card_data)
end

quit = false

while quit == false
  puts "Please enter a card name to learn more about it!"
  input = gets.chomp
  if input == "quit"
    puts "Bye!"
    quit = true
  else
    if selected_card.card_type == "creature"
      selected_card = decklist.find { |card| card.card_title == input }
      puts "#{selected_card.card_title} is a #{selected_card.power} power creature in #{selected_card.house}. The card text reads: #{selected_card.card_text}. It has #{selected_card.armor} armor."
    else
      puts "TODO: other card types"
    end
  end
end