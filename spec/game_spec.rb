require 'rspec'
require 'game'
require 'byebug'

describe Game do
  describe "#initialize" do
    subject(:game) {Game.new}

    it "should start with two players" do
      expect(game.players.count).to eq(2)
    end

    it "should start the game with a deck" do
      expect(game.deck).not_to eq(nil)
    end

    it "should shuffle the deck" do
      unsorted_deck = Deck.new
      expect(game.deck.get_cards).not_to eq(unsorted_deck.get_cards)
    end
  end

  describe "#start_game" do

    it "should give both players half of the deck" do
      game = Game.new
      allow(game).to receive(:game_over?).and_return(true)
      game.start_game
      expect(game.players.all? {|player| player.hand.cards.count == 26}).to eq(true)
    end

    it "should loop play_turn until game is over" do
      game = Game.new
      allow(game).to receive(:game_over?).and_return(true)
      expect(game).not_to receive(:play_turn)
      game.start_game
    end

  end

  describe "#game_over?" do
    subject(:game) {Game.new}

    it "should return false if game not over" do
      game.players.each { |player| player.get_hand(game.deck.deal_halves) }
      expect(game.game_over?).to eq(false)
    end

    it "should return true if game is over" do
      game.players.each { |player| player.get_hand(game.deck.deal_halves) }
      game.players.each {|player| player.hand.cards = []}
      expect(game.game_over?).to eq(true)
    end
  end

  describe "#process_fight" do
    subject(:game) {Game.new}

    before(:each) do
      game.players.each { |player| player.get_hand(game.deck.deal_halves) }
    end

    it "should add both winner and loser's temporary cards to winner's discard pile" do
      player1 = game.player1
      player2 = game.player2
      expect(player1).to receive(:add_claimed_cards)
      game.process_fight(player1, player2)
    end

    it "should clear the temporary discard pile of both winner and loser" do
      player1 = game.player1
      player2 = game.player2
      game.process_fight(player1, player2)
      expect(player1.hand.temporary_discard).to eq([])
      expect(player2.hand.temporary_discard).to eq([])
    end
  end

  describe "#play_turn" do
    subject(:game) {Game.new}
    before(:each) do
      game.players.each { |player| player.get_hand(game.deck.deal_halves) }
    end
    it "should correctly process winner of a card fight" do
      player1 = game.player1
      player2 = game.player2
      card1 = Card.new(:clubs, :ace)
      card2 = Card.new(:hearts, :ten)
      card3 = Card.new(:clubs, :jack)
      card4 = Card.new(:hearts, :six)
      player1.hand.cards.unshift(card4)
      player1.hand.cards.unshift(card1)
      player2.hand.cards.unshift(card3)
      player2.hand.cards.unshift(card2)
      game.play_turn
      game.play_turn
      expect(player1.hand.discard.count).to eq(2)
      expect(player2.hand.discard.count).to eq(2)
    end

    it "should repeat play_turn if fight results in draw" do
      player1 = game.player1
      player2 = game.player2
      card1 = Card.new(:clubs, :ace)
      card2 = Card.new(:hearts, :ace)
      card3 = Card.new(:clubs, :jack)
      card4 = Card.new(:hearts, :six)
      card5 = Card.new(:clubs, :queen)
      card6 = Card.new(:clubs, :six)
      all_cards = [card5, card6, card4, card3, card2, card1]
      player1.hand.cards.unshift(card5)
      player2.hand.cards.unshift(card6)
      player1.hand.cards.unshift(card3)
      player2.hand.cards.unshift(card4)
      player1.hand.cards.unshift(card1)
      player2.hand.cards.unshift(card2)
      game.play_turn
      expect(player1.hand.discard.count).to eq(6)
      expect(player1.hand.discard.sort).to eq(all_cards.sort)
    end

  end

  describe "#winner" do
    subject(:game) {Game.new}
    before(:each) do
      game.players.each { |player| player.get_hand(game.deck.deal_halves) }
    end

    it "correctly assigns a winner" do
      game.player1.hand.cards = []
      expect(game.winner).to eq(game.player2)
    end
  end
end
