# frozen_string_literal: true

require_relative '../lib/connect_four'

RSpec.describe Game do
  subject(:game) { described_class.new(player_one, player_two) }

  let(:player_one) { Player.new('Alice', 'X') }
  let(:player_two) { Player.new('Bob', 'O') }

  describe '#initialize' do
    it 'stores both players' do
      expect(game.players).to eq([player_one, player_two])
    end

    it 'starts with player one' do
      expect(game.current_player).to eq(player_one)
    end

    it 'creates a new board' do
      expect(game.board).to be_a(Board)
    end
  end

  describe '#switch_turn' do
    it 'switches to player two' do
      game.switch_turn
      expect(game.current_player).to eq(player_two)
    end

    it 'switches back to player one' do
      2.times { game.switch_turn }
      expect(game.current_player).to eq(player_one)
    end
  end

  describe '#play_turn' do
    it 'places the current player token on the board' do
      game.play_turn(0)
      expect(game.board.grid[5][0]).to eq('X')
    end

    it 'switches players after a valid move' do
      game.play_turn(0)
      expect(game.current_player).to eq(player_two)
    end

    it 'does not switch players after an invalid move' do
      game.play_turn(7)
      expect(game.current_player).to eq(player_one)
    end

    it 'returns false for an invalid move' do
      expect(game.play_turn(7)).to be false
    end

    it 'returns true for a valid move' do
      expect(game.play_turn(0)).to be true
    end
  end

  describe '#game_over?' do
    it 'returns false when the game is ongoing' do
      expect(game.game_over?).to be false
    end

    it 'returns true when a player wins' do
      allow(game.board).to receive(:winner).and_return('X')
      expect(game.game_over?).to be true
    end

    it 'returns true when the board is a draw' do
      allow(game.board).to receive(:draw?).and_return(true)
      expect(game.game_over?).to be true
    end
  end
end
