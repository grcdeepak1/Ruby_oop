class Move
  attr_reader :value
  VALUES = ['rock', 'paper', 'scissors'].freeze
  def initialize(value)
    @value = value
  end

  def to_s
    value
  end

  def rock?
    value == 'rock'
  end

  def paper?
    value == 'paper'
  end

  def scissors?
    value == 'scissors'
  end

  def >(other_move)
    (value == 'rock' && other_move.scissors?) ||
      (value == 'paper' && other_move.rock?) ||
      (value == 'scissors' && other_move.paper?)
  end
end

class Player
  attr_accessor :name, :move
  def initialize
    set_name
  end

  def to_s
    name
  end
end

# Subclasses
class Human < Player
  def set_name
    puts 'Please enter your name'
    n = ''
    loop do
      n = gets.chomp
      break unless n.empty?
      puts 'Name is required to continue'
    end
    self.name = n
  end

  def choose
    puts "#{name}, Please select rock/paper/scissors"
    m = ''
    loop do
      m = gets.chomp
      break if Move::VALUES.include?(m)
      puts 'Please enter a valid string'
    end
    self.move = Move.new(m)
    puts "#{name} choose #{move}"
  end
end

class Computer < Player
  NAMES = ['R2D2', 'Chitti'].freeze

  def set_name
    self.name = NAMES.sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
    puts "#{name} choose #{move}"
  end
end

# Game Engine
class RpsGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def welcome_msg
    puts 'Welcome to Rock/Paper/Scissors'
  end

  def display_winner
    if human.move > computer.move
      puts "#{human} won!"
    elsif computer.move > human.move
      puts "#{computer} won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    puts "Do you want to play again ? (y/n)"
    ret = gets.chomp
    return true if ret == 'y'
  end

  def game
    welcome_msg
    loop do
      human.choose
      computer.choose
      display_winner
      break if play_again? != true
    end
  end
end

RpsGame.new.game
