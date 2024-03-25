require 'spec_helper'
require 'json'

RSpec.describe 'quake_game_death_cause command' do
  it 'prints a message with the help when comand usage is wrong' do
    expect do
      system('./exe/quake_game_death_cause')
    end.to output("\nCommand needs an argument\nUSAGE: quake_game_death_cause <file path>\n\n").to_stdout_from_any_process
  end

  it 'prints help message with -h argument' do
    expect do
      system('./exe/quake_game_death_cause -h')
    end.to output("\nUSAGE: quake_game_death_cause <file path>\n\n").to_stdout_from_any_process
  end

  it 'prints help message with --help argument' do
    expect do
      system('./exe/quake_game_death_cause --help')
    end.to output("\nUSAGE: quake_game_death_cause <file path>\n\n").to_stdout_from_any_process
  end

  it 'outputs the right json when sending file' do
    expected_outout = {
      game_1: { 'kills_by_means' => { 'MOD_TRIGGER_HURT' => 1, 'MOD_ROCKET_SPLASH' => 1 } },
      game_2: { 'kills_by_means' => { 'MOD_ROCKET' => 2, 'MOD_RAILGUN' => 2, 'MOD_ROCKET_SPLASH' => 1 } }
    }

    expect do
      system('./exe/quake_game_death_cause ./spec/fixtures/log_files/sample_log_file.txt')
    end.to output("#{JSON.pretty_generate(expected_outout)}\n").to_stdout_from_any_process
  end
end
