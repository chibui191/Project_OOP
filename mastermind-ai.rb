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

module AnalyizeFeedback
  def get_xx(feedbackArr)
    @xx = feedbackArr.count('XX')
  end

  def get_xo(feedbackArr)
    @xo = feedbackArr.count('XO')
  end

  def get_oo
    @oo = feedbackArr.count('OO')
  end

  def get_x(feedbackArr)
    @xo + @xx
  end
end

module Attempt
  include AnalyizeFeedback
  def attempt_01
    # Attempt #1: - 1122
    @attempt_count += 1
    puts "Our computer's attempt ##{@attempt_count}:"
    attempt1 = [1,1,2,2]
    @current_guess_board.get_guesses << attempt1
    puts attempt1.inspect
    feedbackArr = feedback(attempt1)
    @current_guess_board.display
    review_01(feedbackArr)
  end

  def review_01(feedbackArr)
    if get_xx(feedbackArr) == 4
      puts "Congratulations! That is indeed the Secret Code."
      puts @secret_code.inspect
    else
      case get_x(feedbackArr)
      when 0
        @nums_excluded << 1 << 2
      when 2
        puts "To be continued"

        # Test Case 1: X1 O2
        @nums_included << 1
        @nums_excluded << 2

        # Test Case 2: O1 X2
        @nums_included << 2
        @nums_excluded << 1
      when 4
        @nums_included << 1 << 2
      end
      @nums_maybe = (@numSet - @nums_excluded - @nums_included).to_a
      puts "Nums definitely included: #{@nums_included.inspect}"
      puts "Nums definitely excluded: #{@nums_excluded.inspect}"
      puts "Potential inclusions: #{@nums_maybe.inspect}" 
    end
  end 

  def attempt_02
    @attempt2 = []
    @attempt_count += 1
    @attempt2 += @nums_included.uniq
    additionals = 4 - @nums_included.length
    additionals.times do
      @attempt2 << @nums_maybe.sample
    end
    puts "Our computer's attempt ##{@attempt_count}:"
    @current_guess_board.get_guesses << @attempt2
    puts @attempt2.inspect
    feedbackArr = feedback(@attempt2)
    @current_guess_board.display
    review_02(feedbackArr)
  end

  def review_02(feedbackArr)
    if get_xx(feedbackArr) == 4
      puts "Congratulations! That is indeed the Secret Code."
      puts @secret_code.inspect
    else
      case get_x(feedbackArr)
      when 0
        @nums_excluded += (@attempt2.uniq)
        @nums_excluded.uniq!()
      when 1
        puts "Hmm okay"
      when 2
        puts "To be continued"
      when 3 
        puts "Not bad!"
      when 4
        @nums_included += (@attempt2.uniq)
        @nums_included.uniq!()
      end
      puts "x = #{x}"
    end
    calc_next_guess
  end

  def calc_next_guess
    @next_guess = []
    @next_guess += @nums_included.uniq
    @nums_maybe = (@numSet - @nums_excluded - @nums_included)
    puts "Nums definitely included: #{@nums_included.inspect}"
    puts "Nums definitely excluded: #{@nums_excluded.inspect}"
    puts "Potential inclusions: #{@nums_maybe.inspect}" 
  end

  #compare no. of x in current feedback with x in prev. feedback
  def compare_feedback(feedbackArr)
    prev_fb = 
  end
end

class Game
  include Attempt
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
    puts "Your job is to come up with a Secret Code for the computer to guess."
    puts "You also need to provide a shift key based on which feedback order placement would be generated."
    puts "Every time our computer makes a guess, we will calculate feedback based on the shift key you provided."
    puts "  - (XX) means right number in right position."
    puts "  - (XO) means right number in wrong position."
    puts "  - (OO) means wrong number that is not included in the Secret Code."
    puts "If our computer fails to get your Secret Code right within 10 attempts, you will win the game."
    puts ""
    puts "Alright #{@p1name}, ready? Let's get this game started!"
    @attempt_count = 0
    @current_guess_board = GuessBoard.new

    @numSet = [1,2,3,4,5,6]
    @nums_included = []
    @nums_excluded = []
    @possible_shifts = []
  end 

  def ask_codes
    puts "Please input your Secret Code:"
    secret_input = gets.chomp
    # validate input later
    @secret_code = secret_input.split("").to_a
    puts "Please input an integer for your desired shift key:"
    # validate shift key
    @shiftedBy = (gets.chomp.to_i) % 4
  end 

  def play
    ask_codes
    attempt_01
    2.times do 
      attempt_02
    end
  end 

  def feedback(attempt)
    feedbackArr = []

    attempt.each_with_index do |num, i|
      j = (i + @shiftedBy) % 4
      if num == @secret_code[i].to_i
        feedbackArr[j] = 'XX'
      elsif num != @secret_code[i].to_i && @secret_code.include?(num.to_s)
        feedbackArr[j] = 'XO'
      else
        feedbackArr[j] = 'OO'
      end
    end
    @current_guess_board.get_feedback << feedbackArr
    feedbackArr
  end
end 

Game.new.play