# frozen_string_literal: true

# Represents the Connect Four board.
class Board
  ROWS = 6
  COLUMNS = 7
  CONNECT = 4

  attr_reader :grid

  def initialize
    @grid = Array.new(ROWS) { Array.new(COLUMNS, ' ') }
  end

  def drop_token(column, token)
    return unless column.is_a?(Integer) && column.between?(0, COLUMNS - 1)

    row = @grid.rindex { |cells| cells[column] == ' ' }
    return unless row

    @grid[row][column] = token
  end

  def winner
    ROWS.times do |row|
      COLUMNS.times do |column|
        token = grid[row][column]
        next if token == ' '

        directions = [[0, 1], [1, 0], [1, 1], [1, -1]]

        directions.each do |row_step, column_step|
          return token if winning_direction?(row, column, row_step, column_step, token)
        end
      end
    end

    nil
  end

  def full?
    grid.flatten.none?(' ')
  end

  def draw?
    full? && winner.nil?
  end

  def display
    output = +''

    grid.each do |row|
      output << "| #{row.join(' | ')} |\n"
    end

    output << "1 2 3 4 5 6 7\n"
    output
  end

  private

  def winning_direction?(row, column, row_step, column_step, token)
    CONNECT.times.all? do |step|
      current_row = row + (step * row_step)
      current_column = column + (step * column_step)

      current_row.between?(0, ROWS - 1) &&
        current_column.between?(0, COLUMNS - 1) &&
        grid[current_row][current_column] == token
    end
  end
end

# Represents a Connect Four player.
class Player
  attr_reader :name, :token

  def initialize(name, token)
    @name = name
    @token = token
  end
end

# Controls the Connect Four game.
class Game
  attr_reader :players, :current_player, :board

  def initialize(player_one, player_two)
    @players = [player_one, player_two]
    @current_player = player_one
    @board = Board.new
  end

  def switch_turn
    @current_player = if current_player == players[0]
                        players[1]
                      else
                        players[0]
                      end
  end

  def play_turn(column)
    return false if game_over?

    result = board.drop_token(column, current_player.token)
    return false unless result

    switch_turn
    true
  end

  def game_over?
    !board.winner.nil? || board.draw?
  end
end
