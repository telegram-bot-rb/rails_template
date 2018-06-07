require 'telegram/bot/rspec/integration/rails'
RSpec.configuration.after { Telegram.bot.reset }
