class Card
  include Comparable

  SUIT_STRINGS = {
    :clubs    => "♣",
    :diamonds => "♦",
    :hearts   => "♥",
    :spades   => "♠"
  }

  VALUE_STRINGS = {
    :two   => "2",
    :three => "3",
    :four  => "4",
    :five  => "5",
    :six   => "6",
    :seven => "7",
    :eight => "8",
    :nine  => "9",
    :ten   => "10",
    :jack  => "J",
    :queen => "Q",
    :king  => "K",
    :ace   => "A"
  }

  def self.suits
    SUIT_STRINGS.keys
  end

  def self.values
    VALUE_STRINGS.keys
  end

  attr_reader :suit, :value

  def initialize(suit, value)
    unless Card.suits.include?(suit) && Card.values.include?(value)
      raise "Illegal suit ()#{suit.inspect} or value #{value.inspect})"
    end
    @suit = suit
    @value = value
  end

  def to_s
    VALUE_STRINGS[value] + SUIT_STRINGS[suit]
  end

  def ==(other_card)
    self.value == other_card.value
  end

  def <=>(other_card)
    if value == other_card.value
      0
    elsif value != other_card
      Card.values.index(value) <=> Card.values.index(other_card.value)
    end
  end
end
