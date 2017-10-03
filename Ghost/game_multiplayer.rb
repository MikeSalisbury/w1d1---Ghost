class Game
  def initialize(*players)
    @players = players
    @current_player = @players[0]
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
    idx = (@players.index(@current_player) + 1) % @players.length
    @current_player = @players[idx]
  end

  def win
    @dictionary.include?(@fragment)
  end

  def play_round
    @fragment = ""
    until win
      take_turn(@current_player)
      break if win
      next_player!
    end
    @losses[@current_player] += 1
    next_player!
    record
  end

  def run
    until @players.length == 1
      play_round
      if @losses.values.include?(1)
        @players.delete(@losses.select { |k,v| v == 1 }.keys[0])
        @losses.delete(@losses.select { |k,v| v == 1 }.keys[0])
      end

    end
    # winner = @losses.select { |k,v| v != 5 }.keys[0] }
    p "#{@players[0].name} is the winner!"
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
  steve = Player.new("Steve")
  game = Game.new(mike, karim, steve)
  game.run
end
