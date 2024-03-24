require 'spec_helper'
require 'quake_game/adapters/log_file_reader_adapter'

RSpec.describe LogFileReaderAdapter do
  describe '#call' do
    let(:log_file_path) { 'spec/fixtures/log_files/sample_log_file.txt' }

    it 'calls match_start event when match is started' do
      match_start_proc = proc {}
      subject.subscribe_on(:match_start, &match_start_proc)
      expect(match_start_proc).to receive(:call).twice
      subject.call(log_file_path)
    end

    it 'calls player_join event when player joins the match' do
      player_join_proc = proc {}
      subject.subscribe_on(:player_join, &player_join_proc)
      expected_calls = [{ id: 2, qty: 6 }, { id: 3, qty: 3 }, { id: 4, qty: 2 }, { id: 5, qty: 1 }]
      expected_calls.each do |expectation|
        expect(player_join_proc).to receive(:call).with(expectation[:id]).exactly(expectation[:qty]).times
      end
      subject.call(log_file_path)
    end

    it 'calls player_update event when player updates some info' do
      player_update_proc = proc {}
      subject.subscribe_on(:player_update, &player_update_proc)
      expected_calls = [
        { id: 2, name: 'Isgalamido', qty: 5 }, { id: 2, name: 'Dono da Bola', qty: 3 }, { id: 2, name: 'Mocinha', qty: 1 },
        { id: 3, name: 'Isgalamido', qty: 4 }, { id: 4, name: 'Zeh', qty: 2 }, { id: 5, name: 'Assasinu Credi', qty: 1 }
      ]
      expected_calls.each do |expectation|
        expect(player_update_proc).to receive(:call).with(expectation[:id], expectation[:name]).exactly(expectation[:qty]).times
      end
      subject.call(log_file_path)
    end

    it 'calls kill event when player kills someone' do
      kill_proc = proc {}
      subject.subscribe_on(:kill, &kill_proc)
      expected_calls = [
        [1022, 2, 'MOD_TRIGGER_HURT'], [2, 2, 'MOD_ROCKET_SPLASH'], [2, 4, 'MOD_ROCKET'], [3, 2, 'MOD_RAILGUN'], [3, 4, 'MOD_RAILGUN'],
        [3, 4, 'MOD_ROCKET'], [3, 2, 'MOD_ROCKET_SPLASH']
      ]
      expected_calls.each do |expectation|
        expect(kill_proc).to receive(:call).with(*expectation).once
      end
      subject.call(log_file_path)
    end
  end
end
