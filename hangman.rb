# Hangman is a guessing game for two or more players. One player thinks of a
# word, phrase or sentence and the other tries to guess it by suggesting letters
# or numbers, within a certain number of guesses.
module Hangman

  # The player class stores the players name
  class Player
    attr_reader :name
    def initialize(args)
      @name = args[:name]
    end
  end

  class Board
    attr_reader :word_array, :word
    attr_accessor :guessed_letters

    def initialize
      @word_array = []
      @guessed_letters = []
      create_word_array
      @word = set_word
    end

    def guess(letter)
      @guessed_letters << letter
      @word.split("").all? {|letter| @guessed_letters.include?(letter)}
    end

    def display_board(number_of_wrong_guesses)
      print "#{@word} \n\n"
      print "\nWord: "
      @word.split("").each {|letter| print @guessed_letters.include?(letter) ? "#{letter} " : "_ "}
      print "\n"
      print "Guessed letters: "
      @guessed_letters.each {|letter| print letter + " "}
      print "\n"
      print "Number of Guesses: #{number_of_wrong_guesses}"
      print "\n\n"
    end

    private
    def create_word_array
      File.open("5desk.txt", "r") do |f|
        f.each_line do |line|
          if line.length >= 5 && line.length <= 12
            @word_array << line.downcase.chomp
          end
        end
      end
    end

    def set_word
      @word_array.sample
    end

  end

  class Game
    attr_accessor :player, :board, :number_of_guesses

    def initialize
      create_board
      @number_of_wrong_guesses = 0
      prepare_player
      game_loop
    end

    private

    def game_loop
      game_finished = false
      while !game_finished
        @board.display_board(@number_of_wrong_guesses)
        guess = player_guess
        is_a_winner = send_guess_to_board(guess)
        @number_of_wrong_guesses += 1 if !@board.word.split("").include?(guess)
        if is_a_winner || @number_of_wrong_guesses == 20
          game_finished = true
          is_a_winner ? game_won : game_lost
        end
      end
      play_again
    end

    def prepare_player
      puts "Please enter your name:"
      name = gets.chomp
      create_player(name)
    end

    def create_player(name)
      @player = Player.new(:name => name)
    end

    def create_board
      @board = Board.new
    end

    def player_guess
      good_guess = false
      while !good_guess
        print "Please enter a letter: "
        guess = gets.downcase.chomp
        if good_guess?(guess)
          good_guess = true
        end
      end
      guess
    end

    def good_guess?(guess)
      if letter?(guess) && not_already_chosen?(guess)
        return true
      end
      return false
    end

    def letter?(guess)
      if guess =~ /[A-Za-z]/ && guess.length == 1
        return true
      else
        return false
      end
    end

    def not_already_chosen?(guess)
      if @board.guessed_letters.include?(guess)
        return false
      else
        return true
      end
    end

    def send_guess_to_board(guess)
      winner = @board.guess(guess)
      winner == true ? true : false
    end

    def game_won
      puts "WOOHOO. YOU ARE A WINNER. YOU'RE SO AWESOME. TOUCH ME!"
    end

    def game_lost
      puts "Sorry. You didn't win this time. Why not try again?"
    end

    def play_again
      puts "Would you like to play again? [Y/N]"
      response = gets.downcase.chomp
      if response == "y"
        Hangman::Game.new
      else
        exit
      end
    end

  end

end

Hangman::Game.new