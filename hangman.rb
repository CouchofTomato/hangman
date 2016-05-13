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
      @word_array << guess
      @word.split().all? {|letter| @word_array.include?(letter)}
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
      @number_of_guesses = 0
      prepare_player
      game_loop
    end

    private

    def game_loop
      game_finished = false
      number_of_turns = 0
      while !game_finished
        guess = player_guess
        is_a_winner = send_guess_to_board(guess)
        number_of_turns + 1
        if is_a_winner || number_of_turns == 20
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
      loop do
        print "Please enter a letter: "
        guess = gets.downcase.chomp
        if good_guess?(guess)
          break
        end
      end
    end

    def good_guess?(guess)
      if letter?(guess) && not_already_chosen?(guess)
        return true
      end
      return false
    end

    def letter?(guess)
      guess =~ /[A-Za-z]/
    end

    def not_already_chosen?(guess)
      @board.guessed_letters.include?(guess)
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
