# Hangman is a guessing game for two or more players. One player thinks of a
# word, phrase or sentence and the other tries to guess it by suggesting letters
# or numbers, within a certain number of guesses.
module Hangman

  class WordsArray
    attr_accessor :word_array
    
    def initialize
      @word_array = []
      load_words
    end

    def load_words
      File.open("5desk.txt", "r") do |f|
        f.each_line do |line|
          if line.length >= 5 && line.length <= 12
            @word_array << line.downcase.chomp
          end
        end
      end
    end
  end
  # The player class stores the players name
  class Player
    attr_accessor :name
    def initialize(args)
      @name = args[:name]
    end
  end

  class Board
    def initialize
      set_word
    end

    def set_word
    end
  end

  class Game
    attr_accessor :player, :board

    def prepare_player
      puts "Please enter your name:"
      name = gets.chomp
      @player = Player.new(:name => name)
    end

    def create_board
      @board = Board.new
    end
  end
end

f = Hangman::WordsArray.new