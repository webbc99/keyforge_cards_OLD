class Card
  attr_reader :id, :card_title, :house, :card_type, :front_image, :card_text, :traits, :amber, :power, :armor, :rarity, :flavor_text, :card_number, :expansion, :is_maverick

  def initialize(id, card_title, house, card_type, front_image, card_text, traits, amber, power, armor, rarity, flavor_text, card_number, expansion, is_maverick)
    @id = id
    @card_title = card_title
    @house = house
    @card_type = card_type
    @front_image = front_image
    @card_text = card_text
    @traits = traits
    @amber = amber
    @power = power
    @armor = armor
    @rarity = rarity
    @flavor_text = flavor_text
    @card_number = card_number
    @expansion = expansion
    @is_maverick = is_maverick
  end
end

module CardWrapper
  def self.card(args)
    Card.new(
            args["id"],
            args["card_title"],
            args["house"],
            args["card_type"],
            args["front_image"],
            args["card_text"],
            args["traits"],
            args["amber"],
            args["power"],
            args["armor"],
            args["rarity"],
            args["flavor_text"],
            args["card_number"],
            args["expansion"],
            args["is_maverick"]
            )
  end
end