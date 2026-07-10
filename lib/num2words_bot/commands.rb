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
        "Привет! Я бот для num2words #{Num2words::VERSION}.\n\n#{Presenter.help_text}"
      when '/help'
        Presenter.help_text
      when '/settings'
        Presenter.settings_text(settings)
      when '/locales'
        "Доступные языки:\n#{Utils.list_values(Num2words.available_locales)}\n\nПример: /lang en"
      when '/currencies'
        currencies_text(settings)
      when '/reset'
        SettingsFactory.reset!(settings)
        "Настройки сброшены.\n\n#{Presenter.settings_text(settings)}"
      when '/lang'
        update_locale(arg, settings)
      when '/currency'
        update_currency(arg, settings)
      when '/mode'
        update_enum(arg, settings, :mode, MODES, 'режим')
      when '/case'
        update_enum(arg, settings, :word_case, WORD_CASES, 'регистр')
      when '/minor'
        update_enum(arg, settings, :minor, MINOR_MODES, 'режим')
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
      return "Укажи язык. Пример: /lang en\n\n/locales покажет весь список." if arg.empty?

      locale = Utils.normalize_symbol(arg)
      return "Язык #{arg} не поддерживается.\n\n/locales покажет доступные языки." unless Utils.supported_locale?(locale)

      settings.locale = locale
      settings.currency = Num2words.default_currency(locale) unless Utils.supported_currency?(locale, settings.currency)
      "Язык изменен на #{locale.upcase}.\n\n#{Presenter.settings_text(settings)}"
    end

    def update_currency(arg, settings)
      return "Укажи валюту. Пример: /currency USD\n\n/currencies покажет список." if arg.empty?

      currency = Utils.normalize_currency(arg)
      unless Utils.supported_currency?(settings.locale, currency)
        return "Валюта #{currency} недоступна для #{settings.locale.upcase}.\n\n/currencies покажет доступные валюты."
      end

      settings.currency = currency
      "Валюта изменена на #{Utils.currency_label(settings.locale, currency)}."
    end

    def update_enum(arg, settings, attribute, allowed_values, label)
      return "Укажи #{label}: #{Utils.list_values(allowed_values)}" if arg.empty?

      value = Utils.normalize_symbol(arg)
      return "Неизвестное значение #{arg}. Доступно: #{Utils.list_values(allowed_values)}" unless allowed_values.include?(value)

      settings[attribute] = value
      "#{label.capitalize} изменен на #{value}."
    end

    def update_short(arg, settings)
      return 'Укажи /short on или /short off.' if arg.empty?

      if Utils.on_value?(arg)
        settings.short = true
      elsif Utils.off_value?(arg)
        settings.short = false
      else
        return "Не понял значение #{arg}. Используй /short on или /short off."
      end

      "Краткий формат: #{settings.short ? 'on' : 'off'}."
    end
  end
end
