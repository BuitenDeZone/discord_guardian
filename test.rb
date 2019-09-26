#!/usr/bin/env ruby

require 'cl'
require 'elasticsearch'
require 'discordrb'
require 'awesome_print'
require 'date'
require 'json'

module DiscordGuardian

  module Elasticsearch
    class DispatchLogger
      def initialize(client, prefix, ignored_events = [])
        @client = client
        @prefix = prefix
        @ignored = ignored_events
      end

      def handle(event)
        type = event.type
        data = event.data
        if @ignored.map(&:to_s).include?(type.to_s)
          puts "#{data['@timestamp']} -- event: #{type} [IGNORED] -- #{data.to_json[0..70]}..."
          return
        end
        puts "#{data['@timestamp']} -- event: #{type} -- #{data.to_json[0..70]}..."
        index = [@prefix, type.to_s.downcase].join('_')
        data['@type'] = type
        data['@timestamp'] = DateTime.now.iso8601(3)
        @client.create index: index, type: '_doc', body: data
      end
    end
  end

  module CLI
    class Run < Cl::Cmd
      opt '--elasticsearch-url URL', default: 'http://localhost:9200'
      opt '--elasticsearch-prefix INDEX_PREFIX', default: 'discord_guardian_test'
      opt '--discord-bot-token TOKEN', required: true
      #opt '--discord-client-id ID', required: true
      def run()

        puts "Starting bot"
        bot = Discordrb::Bot.new(
          token: opts[:discord_bot_token],

          parse_self: true,
          compress_mode: :stream
        )
        elastic_client = ::Elasticsearch::Client.new(url: opts[:elasticsearch_url], log: false)
        elastic_logger = ::DiscordGuardian::Elasticsearch::DispatchLogger.new(elastic_client, opts[:elasticsearch_prefix], opts[:ignored_events])

        bot.raw do |event|
          elastic_logger.handle(event)
        end

        puts "This bot's invite URL is #{bot.invite_url}."
        puts 'Click on it to invite it to your server.'

        bot.run 

      end
    end
  end
end



Cl.new('discord_guardian').run(ARGV)
