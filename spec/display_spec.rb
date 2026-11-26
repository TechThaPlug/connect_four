# frozen_string_literal: true

require_relative '../lib/connect_four'

RSpec.describe Board do
  describe '#display' do
    it 'returns a formatted board with numbered columns' do
      board = described_class.new

      expect(board.display).to include('1 2 3 4 5 6 7')
    end

    it 'shows placed tokens' do
      board = described_class.new
      board.drop_token(0, 'X')

      expect(board.display).to include('X')
    end

    it 'displays all six rows' do
      board = described_class.new

      expect(board.display.lines.count).to eq(7)
    end
  end
end
