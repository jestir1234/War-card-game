require 'rspec'
require 'hand'
require 'deck'
require 'byebug'

describe Hand do
  let(:deck) {Deck.new}
  subject(:hand) {deck.deal_halves}

  describe "#initialize" do

    it "should accept cards correctly" do
      deck.shuffle
      expect(hand.cards.count).to eq(26)
    end

    it "should start with an empty discard pile" do
      expect(hand.discard).to eq([])
    end

    it "should start with an empty temporary discard pile" do
      expect(hand.temporary_discard).to eq([])
    end
  end

  describe "#fight" do
    let(:other_card) {double("other_card", :value => :six)}

    it "should remove the top card of the hand" do
      hand.fight(other_card)
      expect(hand.cards.count).to eq(25)
    end

    it "should return 1 for winning card fight" do
      card = Card.new(:clubs, :ace)
      hand.cards.unshift(card)
      expect(hand.fight(other_card)).to eq(1)
    end

    it "should return -1 for losing card fight" do
      card = Card.new(:clubs, :two)
      hand.cards.unshift(card)
      expect(hand.fight(other_card)).to eq(-1)
    end

    it "should return 0 for a draw" do
      card = Card.new(:clubs, :six)
      hand.cards.unshift(card)
      expect(hand.fight(other_card)).to eq(0)
    end

    it "should put fought card in temporary discard pile" do
      card = Card.new(:clubs, :king)
      hand.cards.unshift(card)
      hand.fight(other_card)
      expect(hand.temporary_discard.first).to eq(card)
    end

    it "should refill cards from discard pile if no cards left" do
      hand.cards = []
      expect(hand).to receive(:refill_cards)
      hand.fight(other_card)
    end

    it "should raise an error if other_card is nil" do
      empty_card = nil
      expect {hand.fight(empty_card)}.to raise_error "opponent has no cards left"
    end
  end

  describe "#clear_temporary" do
    it "should clear the temporary discard pile" do
      card = Card.new(:clubs, :king)
      hand.temporary_discard = [card]
      hand.clear_temporary
      expect(hand.temporary_discard).to eq([])
    end
  end

  describe "#face_down" do
    it "should put the top card in the temporary discard pile" do
      card = Card.new(:clubs, :queen)
      hand.cards.unshift(card)
      hand.face_down
      expect(hand.temporary_discard.first).to eq(card)
    end
  end

  describe "#discard_cards" do
    let(:cards) {[
      Card.new(:spades, :ten),
      Card.new(:clubs, :ace)
      ]}

    let(:cards2) {[
      Card.new(:hearts, :jack),
      Card.new(:hearts, :queen)
      ]}

    it "should add cards to the discard pile" do
      hand.discard = cards2
      hand.discard_cards(cards)
      expect(hand.discard).to eq(cards2 + cards)
    end
  end

  describe "refill_cards" do
    let(:other_card) {double("other_card", :value => :ten)}

    it "should raise an error if the discard pile is empty" do
      expect {hand.refill_cards}.to raise_error 'no cards left!'
    end

    it "should add discard pile back to cards" do
      card = Card.new(:clubs, :king)
      hand.cards.unshift(card)
      hand.fight(other_card)
      hand.discard_cards(hand.temporary_discard)
      hand.refill_cards
      expect(hand.cards.last).to eq(card)
    end
  end

  describe "#top_card" do
    it "should put the top card in the temporary discard pile" do
      card = Card.new(:clubs, :queen)
      hand.cards.unshift(card)
      hand.face_down
      expect(hand.temporary_discard.first).to eq(card)
    end

    it "should refill cards if cards is empty" do
      card1 = Card.new(:clubs, :queen)
      card2 = Card.new(:clubs, :king)
      hand.cards = []
      hand.discard = [card1, card2]
      hand.top_card
      expect(hand.cards.count).to eq(1)
    end
  end

  describe "#lost" do
    let(:other_card) {double("other_card", :value => :ten)}
    it "should return false if cards or discard is not empty" do
      hand.cards = []
      hand.discard = [other_card]
      expect(hand.lost?).to eq(false)
    end

    it "should return true if cards and discard pile is empty" do
      hand.cards = []
      hand.discard = []
      expect(hand.lost?).to eq(true)
    end
  end


end
