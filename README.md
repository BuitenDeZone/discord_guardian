# THIS BOT IS VERY VERY WORK IN PROGRESS. But, sharing is caring.

## Discord Guardian Bot

Manage your destiny 2 clan with ease. Keep track of who is spending
a lot of time in voice and who is too afraid to let himself be heard.

## Requirements

You will need an elasticsearch server and a discord bot token.

## Usage

You can start the bot with

```
git clone https://github.com/BuitenDeZone/ruby-discord_guardian_bot.git discord_guardian
cd discord_guardian
bundle install
bundle exec test.rb run
# @TODO: Change this to the proper 'application' name.
```

You can either provide all required arguments or create a config
file: `~/.discord_guardian.yml` or `.discord_guardian.yml` in the
current directory. It's YAML.

You can provide the command line options for each command using a hash:

```
# .discord_guardian.yml
---
# command run
run:
  # --elasticsearch-url
  elasticsearch_url: http://server.url:9200
  # --discord-bot-token
  discord_bot_token: 'YOUR_TOKEN'

```

There is also configuration which can only be done in the configuration
file but should mostly not be used by many users.

```
---
run:
  :ignore_events:
    - 'PRESENCE_UPDATE'
```
