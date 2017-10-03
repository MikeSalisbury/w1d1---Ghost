class Game
  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @current_player = player1
    @fragment = ""
    @dictionary = File.readlines("dictionary.txt").map(&:chomp)
    @losses = Hash.new(0)
  end

  def substring?(string)
    @dictionary.any? {|word| word[0...string.length] == string}
  end

  def valid_play?(string)
    possible_word = @fragment + string
    ("a".."z").to_a.include?(string) && substring?(possible_word)
  end

  def next_player!
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end

    @current_player
  end

  def win
    @dictionary.include?(@fragment)
  end

  def play_round
    @fragment = ""
    until win
      take_turn(@current_player)
      next_player!
    end
    puts "**********"
    puts "#{@current_player.name} WINS THE ROUND"
    puts "**********"
    @losses[next_player!] += 1
    record
  end

  def run
    until @losses.values.include?(5)
      play_round
    end

    winner = @losses.select { |k,v| v != 5 }.keys[0]
    p "#{winner.name} is the winner!"
  end

  def take_turn(player)
    puts "#{player.name}'s turn"
    input = player.guess
    if valid_play?(input)
      @fragment += input
    else
      player.alert_invalid_guess(input)
      take_turn(player)
    end
  end

    # input = player.guess
    # until valid_play?(input)
    #   player.alert_invalid_guess(input)
    #   take_turn(player)
    # end
    #
    # @fragment += input if valid_play?(input)

  def record
    word = "GHOST"
    @losses.each do |player, losses|
      p "#{player.name}: #{word[0...losses]}"
    end
  end

end

class Player
attr_reader :name

  def initialize(name)
    @name = name
  end

  def guess
    input = gets.chomp
  end

  def alert_invalid_guess(input)
    p "#{input} is an invalid move!"
  end
end

if __FILE__ == $PROGRAM_NAME
  mike = Player.new("Mike")
  karim = Player.new("Karim")
  game = Game.new(mike, karim)
  game.run
end
