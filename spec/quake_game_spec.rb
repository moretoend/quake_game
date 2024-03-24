# frozen_string_literal: true

RSpec.describe QuakeGame do
  it 'has a version number' do
    expect(QuakeGame::VERSION).not_to be nil
  end
end
