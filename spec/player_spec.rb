require 'rspec'
require 'player'
require 'deck'

describe Player do

  describe "#initialize" do
    it "should start a player with a name" do
      player = Player.new("Matt")
      expect(player.name).to eq("Matt")
    end

    it "should start a player with a default name" do
      player = Player.new
      expect(player.name).to eq("Human")
    end
  end

  describe "#get_hand" do
    let(:deck) {Deck.new}
    let(:player) {Player.new}
    let(:game) {double("game", :start_game => player.get_hand(deck.deal_halves))}

    it "gives player a hand of 26 cards" do
      game.start_game
      expect(player.hand.cards.count).to eq(26)
    end
  end

  describe "#refill_hand" do
    let(:deck) {Deck.new}
    let(:player) {Player.new}
    let(:other_card) {Card.new(:spades, :ace)}

    it "should refill the player's hand" do
      player.get_hand(deck.deal_halves)
      26.times { player.hand.fight(other_card) }
      player.hand.discard_cards(player.hand.temporary_discard)
      player.refill_hand
      expect(player.hand.cards.count).to eq(26)
    end

    it "should call Hand instance method #refill_card" do
      player.get_hand(deck.deal_halves)
      10.times { player.hand.fight(other_card) }
      expect(player.hand).to receive(:refill_cards)
      player.refill_hand
    end
  end

  describe "#clear_temporary" do
    let(:deck) {Deck.new}
    let(:player) {Player.new}
    it "should delegate to Hand's clear temporary method" do
      player.get_hand(deck.deal_halves)
      expect(player.hand).to receive(:clear_temporary)
      player.clear_temporary
    end
  end

  describe "#put_card_face_down" do
    let(:deck) {Deck.new}
    let(:player) {Player.new}
    it "should delegate to Hand's face_down method" do
      player.get_hand(deck.deal_halves)
      expect(player.hand).to receive(:face_down)
      player.put_card_face_down
    end

    it "should put top card into Hand's temporary discards" do
      player.get_hand(deck.deal_halves)
      player.put_card_face_down
      expect(player.hand.temporary_discard.count).to eq(1)
    end
  end

  describe "#add_claimed_cards" do
    let(:deck) {Deck.new}
    let(:player) {Player.new}
    it "should delegate to Hand's discard_cards method" do
      player.get_hand(deck.deal_halves)
      expect(player.hand).to receive(:discard_cards)
      player.add_claimed_cards
    end
  end

end
