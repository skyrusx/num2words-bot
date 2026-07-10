# frozen_string_literal: true

require_relative 'utils'

module Num2wordsBot
  module Parser
    AMOUNT_PATTERN = /[+-]?\d+(?:[\.,]\d+)?/.freeze
    CURRENCY_PATTERN = /[A-Za-z]{3}/.freeze

    module_function

    def parse_currency_input(text)
      stripped = text.strip
      amount_first = /\A(?<amount>#{AMOUNT_PATTERN})\s+(?<currency>#{CURRENCY_PATTERN})\z/o.match(stripped)
      return [amount_first[:amount], Utils.normalize_currency(amount_first[:currency])] if amount_first

      currency_first = /\A(?<currency>#{CURRENCY_PATTERN})\s+(?<amount>#{AMOUNT_PATTERN})\z/o.match(stripped)
      return [currency_first[:amount], Utils.normalize_currency(currency_first[:currency])] if currency_first

      nil
    end

    def detect_kind(text)
      stripped = text.strip

      return :currency if parse_currency_input(stripped)
      return :datetime if stripped.match?(/\A\d{1,4}[\.\-]\d{1,2}[\.\-]\d{1,4}[ T]\d{1,2}:\d{2}(:\d{2})?/)
      return :time if stripped.match?(/\A\d{1,2}:\d{2}(:\d{2})?\z/)
      return :date if stripped.match?(/\A\d{1,4}[\.\-]\d{1,2}[\.\-]\d{1,4}\z/)
      return :number if stripped.match?(/\A#{AMOUNT_PATTERN}\z/o)

      :unknown
    end

    def command_name_and_arg(text)
      first, rest = text.strip.split(/\s+/, 2)
      command = first.to_s.sub(/@.+\z/, '').downcase

      [command, rest.to_s.strip]
    end
  end
end
