require_relative 'card'
require_relative 'hand'
require 'byebug'

class Deck

  def self.all_cards
    cards = []

    Card.suits.each do |suit|
      Card.values.each do |value|
        cards << Card.new(suit, value)
      end
    end
    cards
  end

  def initialize(cards = Deck.all_cards)
    @cards = cards
  end

  def count
    @cards.count
  end

  def get_cards
    @cards
  end

  def shuffle
    @cards = @cards.shuffle
  end

  def split
    return @cards if @cards.count < 52

    half = []
    other_half = []

    @cards.each_with_index do |card, i|
      if i % 2 == 0
        half << card
      else
        other_half << card
      end
    end
    @cards = other_half

    half
  end

  def deal_halves
    Hand.new(split)
  end
end
