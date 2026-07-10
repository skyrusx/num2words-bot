# frozen_string_literal: true

require 'num2words'

module Num2wordsBot
  Settings = Struct.new(
    :locale,
    :mode,
    :currency,
    :word_case,
    :fraction_style,
    :joiner,
    :date_case,
    :short,
    :minor,
    keyword_init: true
  )

  MODES = %i[auto number currency date time datetime].freeze
  WORD_CASES = %i[default upper downcase capitalize title].freeze
  FRACTION_STYLES = %i[fraction decimal].freeze
  JOINERS = %i[default and].freeze
  DATE_CASES = %i[default genitive].freeze
  MINOR_MODES = %i[always nonzero never].freeze

  module SettingsFactory
    module_function

    def default
      Settings.new(
        locale: :ru,
        mode: :auto,
        currency: Num2words.default_currency(:ru),
        word_case: :default,
        fraction_style: :fraction,
        joiner: :default,
        date_case: :default,
        short: false,
        minor: :always
      )
    end

    def reset!(settings)
      defaults = default
      settings.members.each { |member| settings[member] = defaults[member] }
      settings
    end
  end
end
