# Twenty-One is a card game consisting of a dealer and a player,
# where the players try to get as close to 21 as possible without going over

# Overview:
# - Both players are initially dealt 2 cards from a 52-card deck.
# - The player takes the frist turn and can say 'hit' or 'stay'.
# - If the player busts, he looses. If he stays, it's the dealer's turn.
# - The dealer must hit until his cards add up to at least 17.
# - If he busts, the player wins.
# - If both stay, then the highest total wins else its a push.

# Nouns - card, player, dealer, deck, game, total
# Verbs - deal, hit, stay, busts

# player
# - hit
# - stay
# - busted?
# - total
# dealer
# - hit
# - stay
# - busted?
# - total
# Participant
# Deck
# - deal
# Card
# Game
# - start
module Hand
  def add_card(new_card)
    cards << new_card
  end

  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
    puts ""
  end

  def total
    total = 0
    cards.each do |card|
      total += if card.ace?
                 11
               elsif card.jack? || card.queen? || card.king?
                 10
               else
                 card.face.to_i
               end
    end
    # correct for Aces
    cards.count(&:ace?).times do
      break if total <= 21
      total -= 10
    end

    total
  end

  def busted?
    total > 21
  end

  def stay_limit?
    total > 17
  end
end

class Participant
  include Hand
  COMPUTER_NAMES = ['R2D2', 'Chitti'].freeze
  attr_accessor :name, :cards
  def initialize
    @cards = []
    set_name
  end
end

class Player < Participant
  def to_s
    "Player's name is #{name}"
  end

  def set_name
    puts "Please Enter your name"
    name = nil
    loop do
      name = gets.chomp
      break unless name.empty?
      puts "Please enter a valid name!"
    end
    self.name = name
  end

  def show_flop
    show_hand
  end
end

class Dealer < Participant
  def to_s
    "Dealer's name is #{name}"
  end

  def set_name
    self.name = COMPUTER_NAMES.sample
  end

  def show_flop
    puts "---- #{name}'s Hand ----"
    cards.first.to_s
    puts " ?? "
    puts ""
  end
end

class Deck
  SUITS  = ['H', 'D', 'S', 'C'].freeze
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].freeze
  attr_accessor :cards

  def initialize
    @cards = []
    SUITS.product(VALUES).each do |tuple|
      @cards << Card.new(*tuple)
    end
    @cards.shuffle!
  end

  def deal_one
    cards.pop
  end
end

class Card
  attr_accessor :suit, :value

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def to_s
    "#{face} of #{suit}"
  end

  def face
    case @face
    when 'J' then 'Jack'
    when 'Q' then 'Queen'
    when 'K' then 'King'
    when 'A' then 'Ace'
    else
      @face
    end
  end

  def suit
    case @suit
    when 'H' then 'Hearts'
    when 'D' then 'Diamonds'
    when 'S' then 'Spades'
    when 'C' then 'Clubs'
    end
  end

  def ace?
    face == 'Ace'
  end

  def king?
    face == 'King'
  end

  def queen?
    face == 'Queen'
  end

  def jack?
    face == 'Jack'
  end
end

class Game
  BLACKJACK_AMT = 21
  attr_accessor :player, :dealer, :deck
  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def show_cards
    puts "--------------------"
    puts "#{dealer.name}'s hand"
    puts "--------------------"
    puts dealer.cards
    puts "--------------------"
    puts "#{player.name}'s hand"
    puts "--------------------"
    puts player.cards
  end

  def player_turn
    puts "#{player.name}'s turn..."

    loop do
      puts "Would you like to (h)it or (s)tay?"
      answer = nil
      loop do
        answer = gets.chomp.downcase
        break if ['h', 's'].include?(answer)
        puts "sorry, must enter 'h' or 's'"
      end
      if answer == 's'
        puts "#{player.name} stays.."
        break
      elsif player.busted?
        puts "#{player.name} busted!"
        break
      else
        puts "#{player.name} hits.."
        player.add_card(deck.deal_one)
        player.show_hand
        break if player.busted?
      end
    end
  end

  def dealer_turn
    puts "#{dealer.name}'s turn..."

    loop do
      if dealer.busted?
        puts "#{dealer.name} busted!"
        break
      elsif dealer.stay_limit?
        puts "#{dealer.name} stays.."
        break
      else
        puts "#{dealer.name} hits!"
        dealer.add_card(deck.deal_one)
        dealer.show_hand
      end
    end
    dealer.show_hand
  end

  def show_flop
    dealer.show_flop
    player.show_flop
  end

  def show_hand
    dealer.show_hand
    player.show_hand
  end

  def show_result
    if player.total > dealer.total
      puts "It looks like #{player.name} wins!"
    elsif player.total < dealer.total
      puts "It looks like #{dealer.name} wins!"
    else
      puts "It's a tie!"
    end
  end

  def show_busted
    if player.busted?
      puts "It looks like you busted and #{dealer.name} wins!"
    elsif dealer.busted?
      puts "It looks like #{dealer.name} busted and #{player.name} wins!"
    end
  end

  def start
    2.times do
      dealer.add_card(deck.deal_one)
      player.add_card(deck.deal_one)
    end
    show_flop
    player_turn
    if !player.busted?
      dealer_turn
      if !dealer.busted?
        show_result
      else
        show_busted
      end
    else
      show_busted
    end
  end
end

Game.new.start
