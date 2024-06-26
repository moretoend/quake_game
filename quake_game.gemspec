# frozen_string_literal: true

require_relative 'lib/quake_game/version'

Gem::Specification.new do |spec|
  spec.name = 'quake_game'
  spec.version = QuakeGame::VERSION
  spec.authors = ['Daniel Moreto']
  spec.email = ['dfmoreto@gmail.com']

  spec.summary = 'Gem for Quake game'
  spec.description = 'Gem responsible for handling a Quake game generating reports for game matches'
  spec.homepage = 'https://github.com/moretoend/quake_game'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/moretoend/quake_game'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
