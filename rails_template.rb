### Gems
gem 'telegram-bot'

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'spring-commands-rspec'

  gem 'awesome_print'
  gem 'hirb'
  gem 'pry'
  gem 'pry-byebug', platforms: [:mri]
  gem 'pry-nav', platforms: [:jruby]
  gem 'pry-doc', platforms: [:mri]
  gem 'pry-rails'
end

run 'bundle install'

after_bundle { puts <<-TXT }

There are some required actions after setup. See:

  https://github.com/telegram-bot-rb/rails_template

TXT

### Basics

file 'bin/copy_samples', <<-'RUBY'
#!/usr/bin/env ruby

require 'fileutils'

rails_root = File.expand_path('../../', __FILE__)

%w(
  config/database.sample.yml
  config/secrets.sample.yml
).each do |file|
  source = "#{rails_root}/#{file}"
  target = "#{rails_root}/#{file.sub('.sample', '')}"
  if File.exist?(target)
    puts "#{file}: exists, skipping"
  elsif !File.exist?(source)
    puts "#{file}: not found"
  else
    FileUtils.copy(source, target)
    puts "#{file}: OK"
  end
end
RUBY

run 'chmod +x bin/copy_samples'
run 'echo "\nconfig/database.yml" >> .gitignore'
run 'echo "config/secrets.yml" >> .gitignore'

run 'cp config/database.yml config/database.sample.yml'

file 'config/secrets.sample.yml', <<-YML
development: &dev
  secret_key_base: #{run 'rails secret', capture: true}
  telegram:
    bot:
      token: BOT_TOKEN
      username: BOT_NAME
      # async: true
      # botan:
      #   token: botan_token
      #   # async: true

test:
  secret_key_base: #{run 'rails secret', capture: true}
  telegram:
    bot:
      token: test_bot_token
      username: BOT_NAME

production:
  <<: *dev
YML

run 'rm config/secrets.yml && bin/copy_samples'

### RSpec

generate 'rspec:install'

file '.rspec', <<-TXT
--color
--require rails_helper
TXT

run 'echo "\nspec/examples.txt" >> .gitignore'

### Bot

route 'telegram_webhooks TelegramWebhooksController'

file 'app/controllers/telegram_webhooks_controller.rb', <<-RUBY
class TelegramWebhooksController < Telegram::Bot::UpdatesController
  def start(*)
    respond_with :message, text: t('.hi')
  end
end
RUBY

file 'config/locales/en.yml', <<-YML
en:
  telegram_webhooks:
    start:
      hi: Hi there!
YML

environment <<-RUBY, env: :production
# Set application domain, to be able to run `rake telegram:bot:set_webhook`
# routes.default_url_options = {host: 'yourdomain.com', protocol: 'https'}
RUBY

file 'spec/support/telegram_bot.rb', <<-RUBY
require 'telegram/bot/rspec/integration'
RSpec.configuration.after { Telegram.bot.reset }
RUBY

environment <<-RUBY, env: :test
# Make bots stubbed before processing routes.rb:
  Telegram::Bot::ClientStub.stub_all!
RUBY

file 'spec/requests/telegram_webhooks_spec.rb', <<-RUBY
RSpec.describe TelegramWebhooksController, :telegram_bot do
  describe '#start' do
    subject { -> { dispatch_message '/start' } }
    it { should respond_with_message 'Hi there!' }
  end
end
RUBY
