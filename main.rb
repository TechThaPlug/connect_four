# frozen_string_literal: true

require_relative 'lib/connect_four'

class ConnectFour
  def initialize(input: $stdin, output: $stdout)
    @input = input
    @output = output
  end

  def play
    @output.puts 'Welcome to Connect Four!'
    @output.print 'Enter Player 1 name: '
    player_one = Player.new(@input.gets&.chomp || 'Player 1', 'X')

    @output.print 'Enter Player 2 name: '
    player_two = Player.new(@input.gets&.chomp || 'Player 2', 'O')

    game = Game.new(player_one, player_two)

    until game.game_over?
      @output.puts
      @output.puts game.board.display
      @output.puts "#{game.current_player.name} (#{game.current_player.token}), choose a column (1-7):"

      input = @input.gets
      break unless input

      column = input.strip.to_i - 1

      @output.puts 'Invalid move! Choose a column from 1 to 7 that is not full.' unless game.play_turn(column)
    end

    finish_game(game)
  end

  private

  def finish_game(game)
    @output.puts
    @output.puts game.board.display

    winner_token = game.board.winner

    if winner_token
      winner = game.players.find { |player| player.token == winner_token }
      @output.puts "Congratulations, #{winner.name}! You win!"
    elsif game.board.draw?
      @output.puts "It's a draw!"
    else
      @output.puts 'Game ended.'
    end
  end
end

ConnectFour.new.play if $PROGRAM_NAME == __FILE__
