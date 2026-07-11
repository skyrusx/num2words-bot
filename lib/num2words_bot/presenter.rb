# frozen_string_literal: true

require 'num2words'
require_relative 'utils'

module Num2wordsBot
  module Presenter
    module_function

    def start_text
      <<~TEXT
        Привет! Я перевожу числа, суммы, даты и время в слова.
        Просто отправь значение, например 123 или 21.05 USD.

        Настройки: /settings
        Помощь: /help
        Команды: /commands
      TEXT
    end

    def help_text
      <<~TEXT
        Я сам понимаю, что ты отправил: число, сумму, дату или время.

        Например:
        123, 45.67, 21.05 USD, 2024-08-21, 14:35:42, 2024-08-21 14:35:42

        Если сумма без валюты, использую валюту из настроек.
        Текущие настройки: /settings
        Все команды: /commands
      TEXT
    end

    def commands_text
      <<~TEXT
        Команды:

        /settings - показать настройки
        /commands - список команд
        /help - как пользоваться ботом

        /lang ru - сменить язык
        /currency USD - сменить валюту
        /mode auto - сменить режим ввода

        /case upper - регистр ответа
        /short on - время без секунд
        /minor nonzero - не писать нулевые копейки/центы
        /style decimal - читать дробь по цифрам
        /joiner and - дроби через "и"
        /datecase genitive - родительный падеж даты

        /locales - доступные языки
        /currencies - доступные валюты
        /reset - сбросить настройки
      TEXT
    end

    def command_options_text(command)
      texts = {
        mode: <<~TEXT,
          Режим ввода:

          /mode auto - сам определять по сообщению
          /mode number - считать ввод числом
          /mode currency - считать ввод суммой
          /mode date - считать ввод датой
          /mode time - считать ввод временем
          /mode datetime - считать ввод датой и временем
        TEXT
        word_case: <<~TEXT,
          Регистр ответа:

          /case default - как вернул конвертер
          /case upper - ВСЕ БОЛЬШИМИ БУКВАМИ
          /case downcase - все маленькими буквами
          /case capitalize - первая буква заглавная
          /case title - каждое слово с заглавной буквы
        TEXT
        minor: <<~TEXT,
          Копейки/центы:

          /minor always - всегда показывать
          /minor nonzero - показывать только если не ноль
          /minor never - не показывать
        TEXT
        fraction_style: <<~TEXT,
          Дробные числа:

          /style fraction - как дробь: сорок пять целых шестьдесят семь сотых
          /style decimal - по цифрам после точки: twelve point one two
        TEXT
        joiner: <<~TEXT,
          Соединитель дробей:

          /joiner default - формально: ноль целых пять десятых
          /joiner and - разговорно: ноль и пять десятых
        TEXT
        date_case: <<~TEXT,
          Падеж даты:

          /datecase default - обычная дата
          /datecase genitive - родительный падеж: двадцать первого августа
        TEXT
        lang: <<~TEXT,
          Язык ответа:

          Пример: /lang en
          Все доступные языки: /locales
        TEXT
        currency: <<~TEXT,
          Валюта по умолчанию:

          Пример: /currency USD
          Все доступные валюты: /currencies
        TEXT
      }

      texts.fetch(command)
    end

    def settings_text(settings)
      lines = [
        'Настройки',
        "Язык ответа: #{locale_label(settings.locale)}",
        "Что распознавать: #{mode_label(settings.mode)}",
        "Суммы без валюты: #{Utils.currency_label(settings.locale, settings.currency)}"
      ]

      format_lines = format_settings_lines(settings)
      lines.concat(['', 'Формат ответа:'])
      lines.concat(format_lines)
      lines.join("\n")
    end

    def result_text(kind, value, currency, result, settings)
      result.to_s
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

    def label(group, value)
      labels = {
        mode: {
          auto: 'авто',
          number: 'число',
          currency: 'валюта',
          date: 'дата',
          time: 'время',
          datetime: 'дата и время'
        },
        word_case: {
          default: 'как есть',
          upper: 'верхний',
          downcase: 'нижний',
          capitalize: 'с заглавной',
          title: 'каждое слово с заглавной'
        },
        fraction_style: {
          fraction: 'как дробь',
          decimal: 'по цифрам после точки'
        },
        joiner: {
          default: 'формальный',
          and: 'разговорный, через "и"'
        },
        date_case: {
          default: 'именительный',
          genitive: 'родительный'
        },
        minor: {
          always: 'всегда',
          nonzero: 'если не ноль',
          never: 'не выводить'
        },
        boolean: {
          true => 'да',
          false => 'нет'
        }
      }

      labels.fetch(group).fetch(value, value.to_s)
    end

    def locale_label(locale)
      names = {
        ar: 'Арабский',
        be: 'Белорусский',
        bg: 'Болгарский',
        bn: 'Бенгальский',
        cs: 'Чешский',
        da: 'Датский',
        de: 'Немецкий',
        el: 'Греческий',
        en: 'Английский',
        es: 'Испанский',
        et: 'Эстонский',
        fa: 'Персидский',
        fi: 'Финский',
        fr: 'Французский',
        he: 'Иврит',
        hi: 'Хинди',
        hu: 'Венгерский',
        it: 'Итальянский',
        ja: 'Японский',
        ko: 'Корейский',
        kz: 'Казахский',
        lt: 'Литовский',
        lv: 'Латышский',
        nl: 'Нидерландский',
        pl: 'Польский',
        pt: 'Португальский',
        ro: 'Румынский',
        ru: 'Русский',
        sk: 'Словацкий',
        sr: 'Сербский',
        sv: 'Шведский',
        tr: 'Турецкий',
        uk: 'Украинский',
        zh: 'Китайский'
      }

      name = names[locale]
      name ? "#{name} (#{locale.upcase})" : locale.upcase.to_s
    end

    def mode_label(mode)
      {
        auto: 'сам определять по сообщению',
        number: 'только числа',
        currency: 'только суммы',
        date: 'только даты',
        time: 'только время',
        datetime: 'только дату и время'
      }.fetch(mode, mode.to_s)
    end

    def format_settings_lines(settings)
      lines = []

      lines << case settings.word_case
               when :upper then 'писать ВСЕ БОЛЬШИМИ БУКВАМИ'
               when :downcase then 'писать все маленькими буквами'
               when :capitalize then 'начинать ответ с заглавной буквы'
               when :title then 'начинать каждое слово с заглавной буквы'
               else 'обычный'
               end

      lines << 'читать дробную часть по цифрам после точки' if settings.fraction_style == :decimal
      lines << 'для дробей использовать разговорное "и"' if settings.joiner == :and
      lines << 'дату писать в родительном падеже' if settings.date_case == :genitive
      lines << 'время писать без секунд' if settings.short

      case settings.minor
      when :nonzero
        lines << 'копейки/центы показывать только если они не ноль'
      when :never
        lines << 'копейки/центы не показывать'
      end

      lines.map { |line| "- #{line}" }
    end
  end
end
