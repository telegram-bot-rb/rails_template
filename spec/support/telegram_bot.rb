require 'telegram/bot/rspec/integration'
RSpec.configuration.after { Telegram.bot.reset }
