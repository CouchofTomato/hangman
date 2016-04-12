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
    def initialize
      @word = select_word
    end

    def select_word

    end
  end

  class Game
  end
end

#Classes
## Game
#### number of guesses

## Player
#### name

## Board
#### word
