class Player
  attr_accessor :name, :symbol, :moves

  def initialize name, symbol 
    @name = name
    @symbol = symbol
    @moves = []
  end
end

class Board
  def initialize
    @@positions = [1,2,3,4,5,6,7,8,9]
  end

  def show
    puts ""
    puts " #{@@positions[0]} | #{@@positions[1]} | #{@@positions[2]} "
    puts "---+---+---"
    puts " #{@@positions[3]} | #{@@positions[4]} | #{@@positions[5]} "
    puts "---+---+---"
    puts " #{@@positions[6]} | #{@@positions[7]} | #{@@positions[8]} "
    puts ""
  end

  def positions
    @@positions
  end
end

class Game
  @@winning_combos = [[1,2,3], [1,5,9], [1,4,7], [4,5,6], [7,8,9], [3,5,7], [2,5,8], [3,6,9]]

  def initialize
    puts "---------+-----+---------"
    puts "Hello! Welcome back to Tic-Tac-Toe by Chi Bui!"
    puts "Please input Player X's name:"
    pXname = gets.chomp.upcase!
    puts "Please input Player O's name:"
    pOname = gets.chomp.upcase!
    puts "Now, let's get this game started!"
    @player1 = Player.new(pXname, 'X')
    @player2 = Player.new(pOname, 'O')   
  end

  def play
    @current_board = Board.new
    @current_board.show
    @turn_count = 1
    @winner = ""
    while tie? == false && @winner == ""
      go(whose_turn)
    end
    restart
  end

  def restart
    puts "Wowza wowza!"
    puts "Wanna play this super fun (kinda) game again? ('Y' for Yes, else No):"
    answer = gets.chomp.upcase!
    if answer == "Y"
      Game.new.play
    else
      puts "Fine! Bye Felicia!"
    end
  end

  private
  def go(current_player)
    puts "#{current_player.name}, your turn!"
    puts "Please enter your position (1-9):"
    move = gets.chomp.to_i
    while taken?(move) == true || !(1..9).include?(move)
      puts "Please enter a corrent non-taken position (1-9):"
      move = gets.chomp.to_i
    end
    current_player.moves << move
    @current_board.positions[move - 1] = current_player.symbol
    @turn_count += 1
    puts "Noice!"
    @current_board.show
    if current_player.moves.count >= 3
      check_win(current_player)
    end
  end

  def whose_turn
    player = @turn_count.odd? ? @player1 : @player2
    return player
  end

  def taken?(move)
    @current_board.positions[move - 1].class == Integer ? false : true
  end

  def check_win(player)
    pmoves = player.moves
    @@winning_combos.each do |combo|
      if (combo - pmoves).empty? 
        puts "---------+-----+---------"
        puts "Congrats #{player.name}, you won!"
        puts "---------+-----+---------"
        @winner = player.name
      end
    end
  end
    
  def tie?
    if @current_board.positions.none? Integer 
      puts "---------+-----+---------"
      puts "We've got a tie here!" 
      puts "---------+-----+---------"
      return true 
    else
      return false
    end
  end
end

Game.new.play