# Num2Words Bot

Telegram-бот для преобразования чисел, дробей, денежных сумм, дат и времени в слова.
Работает на базе Ruby-гема `num2words`.

## Возможности

- Числа: `123`, `-42`, `007`
- Дроби: `45.67`, `45,67`
- Валюты: `21.05 USD`, `USD 21.05`, `21,05 RUB`
- Даты: `2024-08-21`, `21.08.2024`
- Время: `14:35`, `14:35:42`
- Дата и время: `2024-08-21 14:35:42`, `2024-08-21T14:35:42`
- Все локали из `Num2words.available_locales`
- Все валюты из `Num2words.available_currencies(locale)`
- Настройки регистра, дробей, падежа даты, краткого времени и вывода младшей денежной единицы
- Inline mode для быстрых преобразований в других чатах

## Примеры

```text
123
сорок пять целых шестьдесят семь сотых
21.05 USD
2024-08-21
14:35:42
```

Бот по умолчанию работает в режиме `auto` и сам распознает тип ввода.

## Команды

```text
/start
/help
/settings
/lang ru
/currency USD
/mode auto|number|currency|date|time|datetime
/case default|upper|downcase|capitalize|title
/minor always|nonzero|never
/short on|off
/style fraction|decimal
/joiner default|and
/datecase default|genitive
/locales
/currencies
/reset
```

## Настройки

- `locale` - язык результата.
- `mode` - режим распознавания: авто, число, валюта, дата, время, дата-время.
- `currency` - валюта по умолчанию для режима `currency`.
- `word_case` - регистр результата.
- `fraction_style` - стиль дробей.
- `joiner` - соединитель дробной части.
- `date_case` - падеж даты.
- `short` - краткий формат времени.
- `minor` - вывод младшей денежной единицы.

## Локальный запуск

```bash
bundle install
```

Создай `.env`:

```dotenv
TELEGRAM_BOT_TOKEN=your_token_here
```

Запуск:

```bash
bundle exec ruby bot.rb
```

Проверка версии `num2words`:

```bash
bundle exec ruby -e 'require "num2words"; puts Num2words::VERSION'
```

Ожидаемая версия:

```text
0.5.0
```

## Технологии

- Ruby 2.7.1
- telegram-bot-ruby
- num2words `~> 0.5.0`
- dotenv

## Лицензия

[MIT](LICENSE)
