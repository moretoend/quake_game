# QuakeGame

This is project focused on geneating a Quake Game model on play based on log input =)

This basically how the business entities are organized

![Quake Game ERM](https://github.com/moretoend/quake_game/blob/main/docs/quake-game-erm.png)

For now, we're only capable on parsing logs to some report, but there future is here

## Installation

This project is published on RubyGems ([check here](https://rubygems.org/gems/quake_game)), so it's very easy to install, you need to simply run:

```
gem install quake_game
```

## Usage

After installing it, two commands will be available for you to use:

1. To generate a summary of matches based on a log file
```
quake_game_report <file path>
```

2. And another one to generate a death cause report for each match
```
quake_game_death_cause <file path>
```

Both commands will print out a JSON with the matches summary and matches death causes summary respectively. Feel free to test it =)

## Want to contribute?

You're welcome to contribute anyway you want.

To open issues, you can access [our issues page](https://github.com/moretoend/quake_game/issues)

Now, if you want to send some code, follow me to start:
1. First of all, you need to have **git** and **ruby** installed.
Don't know how to do it, you can go to [Git Docs](https://git-scm.com) and [Ruby Docs](https://ruby-doc.org/)

2. Ok, with both installed, clone this repository
```
git clone git@github.com:moretoend/quake_game.git
```

3. Then, join the directory and install the gems
```
cd quake_game
bundle install
```

4. Now you can open your favorite Editor and start coding it =)

5. To run the tests you only need this command
```
bundle exec rspec
```

HAPPY CODING!!
