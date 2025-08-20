require 'telegram/bot'
require 'num2words'
require 'dotenv/load'

TOKEN = ENV['TELEGRAM_BOT_TOKEN']

Telegram::Bot::Client.run(TOKEN) do |bot|
  puts "Бот num2words запущен"

  bot.listen do |message|
    case message
    when Telegram::Bot::Types::Message
      case message.text
      when '/start'
        bot.api.send_message(
          chat_id: message.chat.id,
          text: "Привет, #{message.from.first_name}! Я могу переводить числа в слова. Введи число 👇"
        )
      else
        begin
          number = message.text.to_i
          words = Num2words.to_words(number)

          bot.api.send_message(
            chat_id: message.chat.id,
            text: "🔢 #{number} → ✍️ #{words}"
          )
        rescue => e
          bot.api.send_message(
            chat_id: message.chat.id,
            text: "Ошибка: введите число!"
          )
        end
      end
    end
  end
end
