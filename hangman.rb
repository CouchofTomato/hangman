# Hangman is a guessing game for two or more players. One player thinks of a
# word, phrase or sentence and the other tries to guess it by suggesting letters
# or numbers, within a certain number of guesses.
module Hangman

  # The player class stores the players name
  class Player
    attr_accessor :name
    def initialize(args)
      @name = args[:name]
    end
  end

  class Board
    attr_reader :word_array, :word
    attr_accessor :guessed_letters, :hidden_word

    def initialize
      @word_array = []
      @guessed_letters = []
      create_word_array
      @word = set_word
    end

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
    attr_accessor :player, :board

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
  end

end