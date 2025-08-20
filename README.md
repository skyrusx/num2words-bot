# 🤖 Num2Words Bot

**Num2Words Bot** — это Telegram-бот, который переводит числа в слова и суммы в валюту.  
Основан на [num2words](https://github.com/skyrusx/num2words) ruby gem.

---

## ✨ Возможности

- 🔢 Перевод чисел в слова  
  `123 → сто двадцать три`

- 💵 Суммы в валюте  
  `9876.5 → девять тысяч восемьсот семьдесят шесть рублей пятьдесят копеек`

- 🌍 Поддержка разных языков (ru, en, fr, …)

- ⚙️ Лёгкая интеграция в ваши проекты на Ruby и Rails

---

## 🚀 Как пользоваться

Найди бота в Telegram 👉 [@num2words_bot](https://t.me/num2words_bot)  
И отправь любое число:

```
123
```

Бот ответит:

```
🔢 123 → ✍️ сто двадцать три
```

---

## 🛠 Технологии

- [Ruby](https://www.ruby-lang.org/)
- [telegram-bot-ruby](https://github.com/atipugin/telegram-bot-ruby)
- [num2words](https://github.com/skyrusx/num2words)

---

## 📦 Локальный запуск

```bash
git clone https://github.com/skyrusx/num2words-bot.git
cd num2words-bot
bundle install
```

Создай файл `.env`:

```dotenv
TELEGRAM_BOT_TOKEN=твой_токен_от_BotFather
```

Запуск:

```bash
ruby bot.rb
```

---

## 📝 Примеры

```
/start → Привет! Я перевожу числа в слова и валюту. Введи число 👇
123.5 → сто двадцать три целых пять десятых
45.20 (режим валюта) → forty five dollars twenty cents
```

---

## 📜 Лицензия

[MIT](LICENSE)
