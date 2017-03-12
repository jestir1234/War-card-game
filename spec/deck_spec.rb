require 'rspec'
require 'deck'


describe Deck do
  describe "#::all_cards" do
    subject(:all_cards) {Deck.all_cards}

    it "should generate 52 cards" do
      expect(all_cards.count).to eq(52)
    end

    it "returns all cards without duplicates" do
      expect(all_cards.map {|card| [card.suit, card.value]}.uniq.count).to eq(all_cards.count)
    end
  end

  let(:cards) do
    [ double("card", :suit => :spades, :value => :jack),
      double("card", :suit => :hearts, :value => :seven),
      double("card", :suit => :clubs, :value => :ace) ]
  end

  describe "#initialize" do
    it "by default fills itself with 52 cards" do
      deck = Deck.new
      expect(deck.count).to eq(52)
    end

    it "can be initialized with an array of cards" do
      deck = Deck.new(cards)
      expect(deck.count).to eq(3)
    end
  end

  let(:deck) {Deck.new}

  it "should not expose its cards" do
    expect(deck).not_to respond_to(:cards)
  end

  describe "#shuffle" do
    it "should shuffle the deck" do
      previous_deck = deck.get_cards
      deck.shuffle
      expect(deck.get_cards).not_to eq(previous_deck)
    end
  end

  describe "#split" do
    it "should return half the deck" do
      expect(deck.split.count).to eq(26)
    end

    it "should split the deck in alternating order and return one half" do
      deck.shuffle
      half_deck = []

      previous_deck = deck.get_cards
      previous_deck.each_with_index do |card, i|
        half_deck << card if i % 2 == 0
      end

      expect(deck.split).to eq(half_deck)
    end

    it "should remove half the cards from the deck" do
      deck.split
      expect(deck.get_cards.count).to eq(26)
    end
  end

  describe "#deal_halves" do
    let(:deck) {Deck.new}
    let(:hand) {double("hand")}

    it "should give split decks to hand" do
      hand = deck.deal_halves
      expect(hand).to be_a(Hand)
      expect(hand.cards.count).to eq(26)
    end

    it "should give different halves to each hand" do
      deck.shuffle
      hand1 = deck.deal_halves
      hand2 = deck.deal_halves
      expect(hand1.cards).not_to eq(hand2.cards)
    end

  end

  describe "#count" do
    let(:deck) {Deck.new}

    it "should return how many cards are in the deck" do
      expect(deck.count).to eq(52)
    end
  end
end
