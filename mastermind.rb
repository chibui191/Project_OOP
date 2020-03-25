class GuessBoard
  def initialize
    @@guess_history = []
    @@feedback_history = []
  end

  def display
    puts ""
    @@guess_history.each_with_index do |attempt, i|
      puts "+-----+-----+-----+-----+"
      puts "|  #{attempt[0]}  |  #{attempt[1]}  |  #{attempt[2]}  |  #{attempt[3]}  |"
      puts "+----(#{@@feedback_history[i][0]})(#{@@feedback_history[i][1]})(#{@@feedback_history[i][2]})(#{@@feedback_history[i][3]})---+"
    end  
    puts "+-----+-----+-----+-----+"
    puts ""
  end

  def get_guesses
    @@guess_history
  end

  def get_feedback
    @@feedback_history
  end
end

class Code
  attr_reader :secret_code
  def initialize
    @secret_code = []
    4.times do
      @secret_code << rand(1..6)
    end
  end
end

class Game
  # generate a random code
  def initialize
    puts "---------+-----+---------"
    puts "Hello! Welcome back to MASTERMIND by Chi Bui!"
    puts "What's your name?"
    @p1name = gets.chomp.upcase!
    puts ""
    puts "+-----+-----+-----+-----+"
    puts "|  ?  |  ?  |  ?  |  ?  |"
    puts "+-----+-----+-----+-----+"
    puts ""
    puts "Each ? would be 1 random number within 1-6. Duplicates are allowed."
    puts "Every time you make a guess, we will provide feedback to help you get closer to the Secret Code:"
    puts "(XX) means right number in right position."
    puts "(XO) means right number in wrong position."
    puts "(OO) means wrong number that is not included in the Secret Code."
    puts "Note that Feedback code placement are not necessarily in the same order as the Secret Code."
    puts "If you get it right within 10 attempts, you will win the game."
    puts ""
    puts "Alright #{@p1name}, ready? Let's get this game started!"
  end

  def play
    @current_code = Code.new
    @current_guess_board = GuessBoard.new
    @attempt_count = 0
    @winner = ""
    @shiftedBy = rand(3)

    while @attempt_count < 10 && @winner == ""
      @attempt_count += 1
      puts "Attempt ##{@attempt_count}:"
      puts "Please input your guess (i.e., 1123):"
      input = gets.chomp
      while validated?(input) == false
        puts "Please enter 4 correct numbers between 1-6 only (i.e., 1346):"
        input = gets.chomp
      end
      inputArr = input.split("").to_a
      @current_guess_board.get_guesses << inputArr
      feedback(inputArr)
      @current_guess_board.display
      check_win(inputArr)
    end

    if @winner == ""
      puts "Oopsie Daisy, you lost this round."
    end
    puts "The Secret Code is:" 
    puts "+-----+-----+-----+-----+"
    puts "|  #{@current_code.secret_code[0]}  |  #{@current_code.secret_code[1]}  |  #{@current_code.secret_code[2]}  |  #{@current_code.secret_code[3]}  |"
    puts "+-----+-----+-----+-----+"
  end

  def feedback(inputArr)
    feedbackArr = []
    
    inputArr.each_with_index do |input, i|
      j = (i + @shiftedBy) % 4
      if input.to_i == @current_code.secret_code[i] 
        feedbackArr[j] = 'XX'
      elsif input.to_i != @current_code.secret_code[i] && @current_code.secret_code.include?(input.to_i)
        feedbackArr[j] = 'XO'
      else
        feedbackArr[j] = 'OO'
      end
    end
    @current_guess_board.get_feedback << feedbackArr
  end

  def check_win(inputArr)
    inputArr.each_with_index do |input, i|
      if input.to_i != @current_code.secret_code[i]
        return false
      end
    end
    puts "Congratulations #{@p1name}! You've got it right in #{@attempt_count} moves!"
    @winner = "#{@p1name}"
    return true
  end

  def validated?(input)
    inputArr = input.split("").to_a
    if input.to_i >= 6666 || input.to_i <= 1000
      return false
    else
      inputArr.each do |num|
        if !(1..6).include?(num.to_i)
          return false
        end
      end
    end
    return true
  end
end

Game.new.play