module Hangman

  class Player
    attr_reader :name
    def initialize(args)
      @name = args[:name]
    end
  end

  class Board
    attr_reader :word
    attr_accessor :guessed_letters

    def initialize(args)
      @word = args[:word]
      @guessed_letters = args[:guessed_letters]
    end

    def guess(letter)
      @guessed_letters << letter
      @word.split("").all? {|letter| @guessed_letters.include?(letter)}
    end

    def display_board(number_of_wrong_guesses)
      print "\nWord: "
      @word.split("").each {|letter| print @guessed_letters.include?(letter) ? "#{letter} " : "_ "}
      print "\n"
      print "Guessed letters: "
      @guessed_letters.each {|letter| print letter + " "}
      print "\n"
      print "Number of wrong guesses: #{number_of_wrong_guesses}"
      print "\n\n"
    end
  end

  class Game

    attr_accessor :word_creator, :menu, :file_array, :number_of_wrong_guesses, :board, :player
    attr_reader :word

    def initialize
      @file_array = []
      initial_menu
      response = menu_response
      if response == 1
        new_game
      else
        load_game
      end
    end

    private

    def start_game(args)
      @number_of_wrong_guesses = args[:number_of_wrong_guesses]
      game_loop
    end

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
        puts "would you like to save the game?"
        response = gets.chomp.downcase
        if response == "y"
          save_game(:name => @player.name, :word => @board.word, 
            :guessed_letters => @board.guessed_letters, 
            :number_of_wrong_guesses => @number_of_wrong_guesses)
          puts "would you like to continue or end the game?"
          puts "press 1 to exit or any other key to continue"
          response = gets.chomp
          if response == "1"
            exit
          end
        end
      end
      play_again
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

    def create_word
      Hangman::WordSelecter.new.set_word
    end

    def create_board(args)
      @board = Hangman::Board.new(args)
    end

    def create_file_array
      Dir.foreach("game_saves") do |file|
        next if file == '.' or file == '..'
        @file_array << file
      end
    end

    def initial_menu
      puts "\n-----------MENU-----------"
      puts "Please select an option"
      puts "1: New Game"
      puts "2: Load Game"
      puts "--------------------------\n"
    end

    def new_game
      word = create_word
      prepare_player
      create_board(:word => word, :guessed_letters => [])
      start_game(:number_of_wrong_guesses => 0)
    end

    def save_game(args)
      guessed_letters = args[:guessed_letters].join()
      puts "Please enter a name for the file"
      response = gets.chomp
      response = "#{response}.txt"
      File.open("game_saves/#{response}","w") do |infile|
        infile.puts "#{args[:name]}"
        infile.puts "#{args[:word]}"
        infile.puts "#{guessed_letters}"
        infile.puts "#{args[:number_of_wrong_guesses]}"
      end
    end

    def load_game
      create_file_array
      game = choose_game
      game_to_load = file_array[game]
      game_array = []
      File.open("game_saves/#{game_to_load}", "r") do |infile|
        while line = infile.gets
          game_array << line.chomp
        end
      end
      create_player(game_array[0])
      create_board(:word => game_array[1], :guessed_letters => game_array[2].split(""))
      start_game(:number_of_wrong_guesses => game_array[3].to_i)
    end

    def choose_game
      puts "Please enter the game to load by choosing the relevant number"
      @file_array.each_with_index {|index, game| puts "#{index}: #{game}"}
      good_response = false
      while !good_response
        print "response: "
        response = gets.chomp.to_i
        if response >= 0 && response < @file_array.length
          good_response = true
        end
      end
      response.to_i
    end

    def menu_response
      good_response = false
      while !good_response
        response = gets.chomp.to_i
        if response == 1 || response == 2
          good_response = true
        else
          puts "\nPlease enter either 1 for a new game or 2 to load a saved game"
        end
      end
      response
    end

    def prepare_player
      puts "Please enter your name:"
      name = gets.chomp
      create_player(name)
    end

    def create_player(name)
      @player = Player.new(:name => name)
    end

  end

  # class for creating a suitable array of words and selecting a word for the game
  class WordSelecter
    attr_reader :word_array

    def initialize
      @word_array = []
      create_word_array
    end

    def set_word
      @word_array.sample
    end

    private
    def create_word_array
      File.open("5desk.txt", "r") do |f|
        f.each_line do |line|
          if line.chomp.length >= 5 && line.chomp.length <= 12
            @word_array << line.downcase.chomp
          end
        end
      end
    end
  end
end

Hangman::Game.new