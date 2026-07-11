# frozen_string_literal: true

require 'telegram/bot'
require 'num2words'
require_relative 'commands'
require_relative 'converter'
require_relative 'presenter'
require_relative 'settings'

module Num2wordsBot
  class App
    def initialize(token)
      @token = token
      @user_settings = Hash.new { |store, chat_id| store[chat_id] = SettingsFactory.default }
    end

    def run
      abort 'TELEGRAM_BOT_TOKEN is not set' if @token.to_s.empty?

      Telegram::Bot::Client.run(@token) do |bot|
        puts "Бот Num2Words запущен"

        bot.listen do |message|
          handle_update(bot, message)
        end
      end
    end

    private

    def handle_update(bot, message)
      case message
      when Telegram::Bot::Types::Message
        handle_message(bot, message)
      when Telegram::Bot::Types::InlineQuery
        handle_inline_query(bot, message)
      end
    end

    def handle_message(bot, message)
      return unless message.text

      chat_id = message.chat.id
      text = message.text.strip
      settings = @user_settings[chat_id]

      response = if text.start_with?('/')
                   Commands.handle(text, settings)
                 end

      if response
        send_text(bot, chat_id, response)
      else
        kind, value, currency, result = Converter.convert_input(text, settings)
        send_text(bot, chat_id, Presenter.result_text(kind, value, currency, result, settings))
      end
    rescue StandardError => e
      send_text(bot, chat_id, Presenter.error_text(e))
    end

    def handle_inline_query(bot, message)
      query = message.query.to_s.strip
      return if query.empty?

      settings = SettingsFactory.default
      kind, value, currency, result = Converter.convert_input(query, settings)
      title = currency ? "#{value} #{currency} -> #{result}" : "#{value} -> #{result}"
      results = [
        Telegram::Bot::Types::InlineQueryResultArticle.new(
          id: 'num2words-1',
          title: title,
          input_message_content: Telegram::Bot::Types::InputTextMessageContent.new(
            message_text: Presenter.result_text(kind, value, currency, result, settings)
          )
        )
      ]

      bot.api.answer_inline_query(inline_query_id: message.id, results: results)
    rescue StandardError
      bot.api.answer_inline_query(inline_query_id: message.id, results: [])
    end

    def send_text(bot, chat_id, text)
      bot.api.send_message(chat_id: chat_id, text: text)
    end
  end
end
