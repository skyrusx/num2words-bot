# frozen_string_literal: true

require 'num2words'
require_relative 'parser'

module Num2wordsBot
  module Converter
    module_function

    def convert_input(text, settings)
      stripped = text.strip
      detected_kind = Parser.detect_kind(stripped)
      kind = settings.mode == :auto ? detected_kind : settings.mode

      raise Num2words::UnsupportedInputError, stripped if settings.mode == :auto && detected_kind == :unknown

      if settings.mode != :auto && settings.mode != :currency && detected_kind != settings.mode
        raise Num2words::UnsupportedInputError, stripped
      end

      case kind
      when :currency
        parsed = Parser.parse_currency_input(stripped)
        amount, currency = parsed || [stripped, settings.currency]
        result = Num2words.to_currency(amount, **currency_options(settings, currency))
        [:currency, amount, currency, result]
      when :number, :date, :time, :datetime, :auto
        result = Num2words.to_words(stripped, **words_options(settings))
        [kind, stripped, nil, result]
      else
        result = Num2words.to_words(stripped, **words_options(settings))
        [detected_kind, stripped, nil, result]
      end
    end

    def words_options(settings)
      {
        locale: settings.locale,
        word_case: settings.word_case,
        style: settings.fraction_style,
        joiner: settings.joiner,
        date_case: settings.date_case,
        short: settings.short
      }
    end

    def currency_options(settings, currency)
      {
        locale: settings.locale,
        code: currency,
        word_case: settings.word_case,
        minor: settings.minor,
        strict: true
      }
    end
  end
end
