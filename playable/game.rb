require_relative 'player'
require_relative 'deck'

class Game

  attr_accessor :players, :deck, :player1, :player2

  def initialize(player1 = Player.new, player2 = Player.new, deck = Deck.new)
    @players = [player1, player2]
    @player1 = player1
    @player2 = player2
    @deck = deck
    @deck.shuffle
  end

  def start_game
    @players.each { |player| player.get_hand(deck.deal_halves) }
    until game_over?
      self.play_turn
    end

    puts "#{winner.name} has won!"
    puts "\n"
    puts "\n"
    display_info
  end

  def game_over?
    players.any? {|player| player.hand.lost? }
  end

  def get_input
    puts "Ready to fight? (Press any key to cont.)"
    input = gets.chomp
  end

  def display_info
    puts "-------         -------"
    puts "#{player1.name}         #{player2.name}"
    puts "-------         -------"
    puts "\n"
    puts "\n"
    puts "  #{player1.hand.cards.count}       Deck     #{player2.hand.cards.count}"
    puts "  #{player1.hand.discard.count}     Discard    #{player2.hand.discard.count}"
    puts "\n"
  end

  def play_turn
    puts "\n"
    get_input
    system "clear"
    display_info

    begin
      result = player1.hand.fight(player2.hand.top_card)
    rescue
      return
    end


    case result
    when -1
      process_fight(player2, player1)
    when 0
      puts "\n"
      puts "IT'S WAR!"
      begin
        player1.put_card_face_down
        player2.put_card_face_down
      rescue
        return
      end
      play_turn
    when 1
      process_fight(player1, player2)
    end
  end

  def process_fight(winner, loser)
    puts "\n"
    puts "#{winner.name.upcase} WINS THE ROUND!"
    won_cards = loser.hand.temporary_discard
    kept_cards = winner.hand.temporary_discard
    all_cards = won_cards + kept_cards
    puts "\n"
    puts "Added cards:"
    display = ""
    all_cards.each {|card| display += "|#{card.to_s}| "}
    puts display

    winner.add_claimed_cards(won_cards)
    winner.add_claimed_cards(kept_cards)
    winner.clear_temporary
    loser.clear_temporary
  end

  def winner
    player1.hand.lost? ? player2 : player1
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new(player1 = Player.new("Player1"), player2 = Player.new("Player2"), deck = Deck.new)
  game.start_game
end
