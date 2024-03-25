require 'spec_helper'
require 'quake_game/use_cases/game_death_cause_use_case'
require_relative '../support/mocks/log_reader_mock'

RSpec.describe GameDeathCauseUseCase do
  let(:log_reader) { LogReaderMock.new }

  subject { described_class.new(log_reader) }

  it 'returns matches summary' do
    first_match = { player_join: [2, 1, 3, 1], kill: [[1, 2, 'MOD_GAUNTLET'], [1022, 1, 'MOD_FALLING'], [1, 3, 'MOD_GAUNTLET'], [1, 1, 'MOD_GRENADE_SPLASH']] }
    second_match = { player_join: [1, 2, 2], kill: [[1, 2, 'MOD_GAUNTLET'], [1, 2, 'MOD_LIGHTNING']] }

    log_reader.matches_grouped_events = [first_match, second_match]

    expect(subject.call('some_log_file_path.txt')).to eq(
      {
        'game_1' => {
          'kills_by_means' => {
            'MOD_GAUNTLET' => 2,
            'MOD_FALLING' => 1,
            'MOD_GRENADE_SPLASH' => 1
          }
        },
        'game_2' => {
          'kills_by_means' => {
            'MOD_GAUNTLET' => 1,
            'MOD_LIGHTNING' => 1
          }
        }
      }
    )
  end
end
