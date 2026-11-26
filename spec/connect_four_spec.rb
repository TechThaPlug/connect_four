# frozen_string_literal: true

require_relative '../lib/connect_four'

RSpec.describe Board do
  subject(:board) { described_class.new }

  describe '#initialize' do
    it 'creates 6 rows and 7 columns' do
      expect(board.grid.size).to eq(6)
      expect(board.grid.all? { |row| row.size == 7 }).to be true
    end

    it 'starts with every cell empty' do
      expect(board.grid.flatten.uniq).to eq([' '])
    end
  end

  describe '#drop_token' do
    it 'places a token at the bottom of the selected column' do
      board.drop_token(0, 'X')
      expect(board.grid[5][0]).to eq('X')
    end

    it 'stacks tokens from the bottom upwards' do
      board.drop_token(0, 'X')
      board.drop_token(0, 'O')
      expect(board.grid[4][0]).to eq('O')
    end

    it 'rejects columns outside the board' do
      expect(board.drop_token(-1, 'X')).to be_nil
      expect(board.drop_token(7, 'X')).to be_nil
    end

    it 'rejects a non-integer column' do
      expect(board.drop_token('0', 'X')).to be_nil
    end

    it 'rejects a move when the column is full' do
      6.times { board.drop_token(0, 'X') }
      expect(board.drop_token(0, 'O')).to be_nil
    end

    it 'does not modify the board for an invalid column' do
      original_grid = board.grid.map(&:dup)
      board.drop_token(7, 'X')
      expect(board.grid).to eq(original_grid)
    end
  end

  describe '#winner' do
    it 'detects a horizontal win' do
      4.times { |column| board.grid[5][column] = 'X' }
      expect(board.winner).to eq('X')
    end

    it 'detects a vertical win' do
      4.times { |row| board.grid[row][0] = 'O' }
      expect(board.winner).to eq('O')
    end

    it 'detects a diagonal win from bottom left to top right' do
      board.grid[5][0] = 'X'
      board.grid[4][1] = 'X'
      board.grid[3][2] = 'X'
      board.grid[2][3] = 'X'
      expect(board.winner).to eq('X')
    end

    it 'detects a diagonal win from top left to bottom right' do
      board.grid[2][0] = 'O'
      board.grid[3][1] = 'O'
      board.grid[4][2] = 'O'
      board.grid[5][3] = 'O'
      expect(board.winner).to eq('O')
    end

    it 'returns nil when there is no winner' do
      expect(board.winner).to be_nil
    end

    it 'does not detect three consecutive tokens as a win' do
      3.times { |column| board.grid[5][column] = 'X' }
      expect(board.winner).to be_nil
    end

    it 'does not count empty cells as a winning combination' do
      expect(board.winner).to be_nil
    end
  end

  describe '#full?' do
    it 'returns false when empty spaces remain' do
      expect(board.full?).to be false
    end

    it 'returns true when every cell is occupied' do
      board.grid.each { |row| row.map! { 'X' } }
      expect(board.full?).to be true
    end
  end

  describe '#draw?' do
    it 'returns false when the board is empty' do
      expect(board.draw?).to be false
    end

    it 'returns true when the board is full and nobody has won' do
      pattern = %w[
        XXOOXOO
        OXOXOOO
        OXXOXXX
        XOXOXOO
        OOOXXOX
        XXOXOOX
      ]

      board.grid.each_with_index do |row, index|
        row.replace(pattern[index].chars)
      end

      expect(board.draw?).to be true
    end
  end
end
