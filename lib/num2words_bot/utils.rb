# frozen_string_literal: true

require 'num2words'

module Num2wordsBot
  module Utils
    module_function

    def normalize_symbol(value)
      value.to_s.strip.downcase.to_sym
    end

    def normalize_currency(value)
      value.to_s.strip.upcase.to_sym
    end

    def on_value?(value)
      %w[on yes true 1 да вкл enable enabled].include?(value.to_s.strip.downcase)
    end

    def off_value?(value)
      %w[off no false 0 нет выкл disable disabled].include?(value.to_s.strip.downcase)
    end

    def supported_locale?(locale)
      Num2words.available_locales.include?(locale)
    end

    def supported_currency?(locale, currency)
      Num2words.currency_available?(locale, currency)
    end

    def currency_label(locale, currency)
      info = Num2words.currency_info(locale, currency)
      return currency.to_s unless info

      [info[:code], info[:symbol]].compact.join(' ')
    end

    def list_values(values)
      values.map(&:to_s).join(', ')
    end
  end
end
