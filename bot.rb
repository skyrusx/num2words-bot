# frozen_string_literal: true

require 'dotenv/load'
require_relative 'lib/num2words_bot/app'

TOKEN = ENV['TELEGRAM_BOT_TOKEN']

def default_settings
  Num2wordsBot::SettingsFactory.default
end

def convert_input(text, settings)
  Num2wordsBot::Converter.convert_input(text, settings)
end

def handle_command(text, settings)
  Num2wordsBot::Commands.handle(text, settings)
end

def error_text(error)
  Num2wordsBot::Presenter.error_text(error)
end

def result_text(kind, value, currency, result, settings)
  Num2wordsBot::Presenter.result_text(kind, value, currency, result, settings)
end

def run_bot
  Num2wordsBot::App.new(TOKEN).run
end

run_bot if __FILE__ == $PROGRAM_NAME
