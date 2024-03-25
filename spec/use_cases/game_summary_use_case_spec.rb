require 'spec_helper'
require 'quake_game/use_cases/game_summary_use_case'
require_relative '../support/mocks/log_reader_mock'

RSpec.describe GameSummaryUseCase do
  let(:log_reader) { LogReaderMock.new }

  subject { described_class.new(log_reader) }

  it 'returns matches summary' do
    first_match = { player_join: [2, 1, 3, 1], player_update: [[1, 'Isgalamido'], [2, 'Dono da Bola'], [3, 'Mocinha']],
                    kill: [[1, 2, 'MOD_GAUNTLET'], [1022, 1, 'MOD_FALLING'], [1, 3, 'MOD_LIGHTNING'], [1, 1, 'MOD_GRENADE_SPLASH']] }
    second_match = { player_join: [1, 2, 2], player_update: [[1, 'Isgalamido'], [2, 'Dono da Bola']],
                     kill: [[1, 2, 'MOD_GAUNTLET'], [1, 2, 'MOD_LIGHTNING']] }

    log_reader.matches_grouped_events = [first_match, second_match]

    expect(subject.call('some_log_file_path.txt')).to eq(
      {
        'matches' => {
          'game_1' => {
            'total_kills' => 4,
            'players' => ['Dono da Bola', 'Isgalamido', 'Mocinha'],
            'kills' => { 'Dono da Bola' => 0, 'Isgalamido' => 1, 'Mocinha' => 0 }
          },
          'game_2' => {
            'total_kills' => 2,
            'players' => ['Isgalamido', 'Dono da Bola'],
            'kills' => { 'Isgalamido' => 2, 'Dono da Bola' => 0 }
          }
        },
        'rankings' => {
          'game_1' => [
            { 'name' => 'Isgalamido', 'score' => 1 },
            { 'name' => 'Mocinha', 'score' => 0 },
            { 'name' => 'Dono da Bola', 'score' => 0 }
          ],
          'game_2' => [
            { 'name' => 'Isgalamido', 'score' => 2 },
            { 'name' => 'Dono da Bola', 'score' => 0 }
          ]
        }
      }
    )
  end
end
