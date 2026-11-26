# frozen_string_literal: true

require_relative '../lib/connect_four'

RSpec.describe Player do
  subject(:player) { described_class.new('Alice', 'X') }

  describe '#initialize' do
    it 'stores the player name' do
      expect(player.name).to eq('Alice')
    end

    it 'stores the player token' do
      expect(player.token).to eq('X')
    end
  end
end
