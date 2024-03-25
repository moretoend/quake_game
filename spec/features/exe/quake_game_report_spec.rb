require 'spec_helper'
require 'json'

RSpec.describe 'quake_game_report command' do
  it 'prints a message with the help when comand usage is wrong' do
    expect do
      system('./exe/quake_game_report')
    end.to output("\nCommand needs an argument\nUSAGE: quake_game_report <file path>\n\n").to_stdout_from_any_process
  end

  it 'prints help message with -h argument' do
    expect do
      system('./exe/quake_game_report -h')
    end.to output("\nUSAGE: quake_game_report <file path>\n\n").to_stdout_from_any_process
  end

  it 'prints help message with --help argument' do
    expect do
      system('./exe/quake_game_report --help')
    end.to output("\nUSAGE: quake_game_report <file path>\n\n").to_stdout_from_any_process
  end

  it 'outputs the right json when sending file' do
    expected_outout = {
      matches: {
        game_1: { total_kills: 2, players: ['Isgalamido'], kills: { 'Isgalamido' => 0 } },
        game_2: {
          total_kills: 5, players: ['Dono da Bola', 'Isgalamido', 'Zeh', 'Assasinu Credi'],
          kills: { 'Dono da Bola' => 1, 'Isgalamido' => 4, 'Zeh' => 0, 'Assasinu Credi' => 0 }
        }
      },
      rankings: {
        game_1: [
          { name: 'Isgalamido', score: 0 }
        ],
        game_2: [
          { name: 'Isgalamido', score: 4 },
          { name: 'Dono da Bola', score: 1 },
          { name: 'Assasinu Credi', score: 0 },
          { name: 'Zeh', score: 0 }
        ]
      }
    }

    expect do
      system('./exe/quake_game_report ./spec/fixtures/log_files/sample_log_file.txt')
    end.to output("#{JSON.pretty_generate(expected_outout)}\n").to_stdout_from_any_process
  end
end
