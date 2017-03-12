class Player

  attr_reader :name, :hand

  def initialize(name = "Human")
    @name = name
  end

  def get_hand(hand)
    @hand = hand
  end

  def refill_hand
    hand.refill_cards
  end

  def clear_temporary
    hand.clear_temporary
  end

  def put_card_face_down
    hand.face_down
  end

  def add_claimed_cards(cards)
    hand.discard_cards(hand.temporary_discard)
  end
end
