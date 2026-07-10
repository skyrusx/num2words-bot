# frozen_string_literal: true

require 'num2words'
require_relative 'utils'

module Num2wordsBot
  module Presenter
    module_function

    def help_text
      <<~TEXT
        Я превращаю числа, суммы, даты и время в слова через num2words #{Num2words::VERSION}.

        Примеры:
        123
        -42
        45.67
        45,67
        21.05 USD
        USD 21.05
        2024-08-21
        21.08.2024
        14:35
        14:35:42
        2024-08-21 14:35:42

        Команды:
        /settings - текущие настройки
        /lang ru - язык
        /currency USD - валюта
        /mode auto|number|currency|date|time|datetime
        /case default|upper|downcase|capitalize|title
        /minor always|nonzero|never
        /short on|off
        /style fraction|decimal
        /joiner default|and
        /datecase default|genitive
        /locales - все языки
        /currencies - все валюты для текущего языка
        /reset - сброс настроек
      TEXT
    end

    def settings_text(settings)
      <<~TEXT
        Настройки:
        Язык: #{settings.locale.upcase}
        Режим: #{settings.mode}
        Валюта: #{Utils.currency_label(settings.locale, settings.currency)}
        Регистр: #{settings.word_case}
        Дроби: #{settings.fraction_style}
        Соединитель дробей: #{settings.joiner}
        Падеж даты: #{settings.date_case}
        Кратко: #{settings.short ? 'on' : 'off'}
        Младшая денежная единица: #{settings.minor}
      TEXT
    end

    def result_text(kind, value, currency, result, settings)
      source = currency ? "#{value} #{currency}" : value

      <<~TEXT
        #{kind_title(kind)}
        #{source}

        #{result}

        #{settings.locale.upcase} · #{settings.mode}
      TEXT
    end

    def error_text(error)
      case error
      when Num2words::UnsupportedCurrencyError
        "Валюта #{error.currency} недоступна для #{error.locale}. Используй /currencies."
      when Num2words::UnsupportedCurrencyAmountError
        "Некорректная сумма. Примеры: 21.05 USD, USD 21.05, 21,05."
      when Num2words::UnsupportedInputError
        "Не понял ввод. Примеры: 123, 45.67, 21.05 USD, 2024-08-21, 14:35."
      when Num2words::UnsupportedOptionError
        "Некорректная опция #{error.name}: #{error.value.inspect}. Проверь /settings."
      when ArgumentError
        "Не получилось преобразовать ввод: #{error.message}"
      else
        "Произошла ошибка: #{error.class}"
      end
    end

    def kind_title(kind)
      case kind
      when :currency then 'Валюта'
      when :date then 'Дата'
      when :time then 'Время'
      when :datetime then 'Дата и время'
      when :number then 'Число'
      else 'Результат'
      end
    end
  end
end
