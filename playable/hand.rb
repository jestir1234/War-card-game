class Hand

  attr_accessor :cards, :discard, :temporary_discard

  def initialize(cards)
    @cards = cards
    @discard = []
    @temporary_discard = []
  end

  def fight(other_card)
    raise "opponent has no cards left" if other_card.nil?
    self.refill_cards if @cards.empty?
    fight_card = @cards.shift
    puts " |#{fight_card.to_s}| <============> |#{other_card.to_s}|"
    @temporary_discard << fight_card
    fight_card <=> other_card
  end

  def clear_temporary
    @temporary_discard = []
  end

  def face_down
    refill_cards if @cards.empty?
    @temporary_discard << @cards.shift
  end

  def top_card
    refill_cards if @cards.empty?
    card = @cards.shift
    @temporary_discard << card
    card
  end

  def refill_cards
    if @discard.empty?
      raise 'no cards left!'
    end
    @cards += @discard
    @discard = []
  end

  def lost?
    @cards.empty? && @discard.empty?
  end

  def discard_cards(cards)
    @discard += cards
  end

end
