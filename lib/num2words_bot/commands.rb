# frozen_string_literal: true

require 'num2words'
require_relative 'parser'
require_relative 'presenter'
require_relative 'settings'
require_relative 'utils'

module Num2wordsBot
  module Commands
    module_function

    def handle(text, settings)
      command, arg = Parser.command_name_and_arg(text)

      case command
      when '/start'
        Presenter.start_text
      when '/help'
        Presenter.help_text
      when '/commands'
        Presenter.commands_text
      when '/settings'
        Presenter.settings_text(settings)
      when '/locales'
        "Доступные языки:\n#{Utils.list_values(Num2words.available_locales)}\n\nПример: /lang en"
      when '/currencies'
        currencies_text(settings)
      when '/reset'
        SettingsFactory.reset!(settings)
        'Настройки сброшены.'
      when '/lang'
        update_locale(arg, settings)
      when '/currency'
        update_currency(arg, settings)
      when '/mode'
        update_enum(arg, settings, :mode, MODES, 'режим')
      when '/case'
        update_enum(arg, settings, :word_case, WORD_CASES, 'регистр')
      when '/minor'
        update_enum(arg, settings, :minor, MINOR_MODES, 'копейки/центы')
      when '/short'
        update_short(arg, settings)
      when '/style'
        update_enum(arg, settings, :fraction_style, FRACTION_STYLES, 'стиль дробей')
      when '/joiner'
        update_enum(arg, settings, :joiner, JOINERS, 'соединитель')
      when '/datecase'
        update_enum(arg, settings, :date_case, DATE_CASES, 'падеж даты')
      else
        nil
      end
    end

    def currencies_text(settings)
      options = Num2words.currency_options(settings.locale)
      labels = options.map { |label, code| "#{code} (#{label})" }
      "Валюты для #{settings.locale.upcase}:\n#{labels.join(', ')}\n\nПример: /currency USD"
    end

    def update_locale(arg, settings)
      return Presenter.command_options_text(:lang) if arg.empty?

      locale = Utils.normalize_symbol(arg)
      return "Язык #{arg} не поддерживается.\n\n/locales покажет доступные языки." unless Utils.supported_locale?(locale)

      settings.locale = locale
      settings.currency = Num2words.default_currency(locale) unless Utils.supported_currency?(locale, settings.currency)
      "Язык: #{locale.upcase}"
    end

    def update_currency(arg, settings)
      return Presenter.command_options_text(:currency) if arg.empty?

      currency = Utils.normalize_currency(arg)
      unless Utils.supported_currency?(settings.locale, currency)
        return "Валюта #{currency} недоступна для #{settings.locale.upcase}.\n\n/currencies покажет доступные валюты."
      end

      settings.currency = currency
      "Валюта: #{Utils.currency_label(settings.locale, currency)}"
    end

    def update_enum(arg, settings, attribute, allowed_values, label)
      return Presenter.command_options_text(attribute_label_group(attribute)) if arg.empty?

      value = Utils.normalize_symbol(arg)
      return "Неизвестное значение #{arg}. Доступно: #{Utils.list_values(allowed_values)}" unless allowed_values.include?(value)

      settings[attribute] = value
      "#{label.capitalize}: #{Presenter.label(attribute_label_group(attribute), value)}"
    end

    def update_short(arg, settings)
      return "Краткое время:\n\n/short on - не показывать секунды\n/short off - показывать полное время" if arg.empty?

      if Utils.on_value?(arg)
        settings.short = true
      elsif Utils.off_value?(arg)
        settings.short = false
      else
        return "Не понял значение #{arg}. Используй /short on или /short off."
      end

      "Кратко: #{Presenter.label(:boolean, settings.short)}"
    end

    def attribute_label_group(attribute)
      {
        mode: :mode,
        word_case: :word_case,
        minor: :minor,
        fraction_style: :fraction_style,
        joiner: :joiner,
        date_case: :date_case
      }.fetch(attribute)
    end
  end
end
