# Template for tiny Rails app with Telegram bot

Here you can find template for tiny Rails application with Telegram bot.
The repository itself is generated with this template.

What do you get:

- [telegram-bot](https://github.com/telegram-bot-rb/telegram-bot).
- RSpec for tests.
- Pry for debug.
- Simple bot controller.

## Setup

Here is a command to generate smalles possible installation of rails.
Choose yourself what railties to enable:

```
rails new telegram_bot_rails_api \
  --api \
  --skip-action-mailer \
  --skip-active-record \
  --skip-action-cable \
  --skip-test \
  -m https://raw.githubusercontent.com/telegram-bot-rb/rails_template/master/rails_template.rb
```

## After setup:

- Add this lines to `bin/setup`:

    puts "\n== Copying sample files =="
    system 'bin/copy_samples'

- Setup bot config in `config/secrets.yml`.

- Uncomment this line in `spec/rails_helper.rb`:

    Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

- _Optional._ Uncomment default configuration in `spec/spec_helper.rb`.

## Development

    bin/rails telegram:bot:poller

## Deployment

- Edit capistrano config.
- Choose one of deployment ways:

### Receiving webhooks

- Setup domain in `config/environments/production.yml`:

    config.routes.default_url_options = {host: 'yourdomain.com', protocol: 'https'}

- Deploy as usual Rails app.

### Poller

This is an easier way, though not the 'right' one.
You can simply run a rake task, or use something like this:

```ruby
# bin/telegram_bot

#!/usr/bin/env ruby

begin
  require_relative '../config/environment'
  Telegram::Bot::UpdatesPoller.start(ENV['BOT'].try!(:to_sym) || :default)
rescue Exception => e
  Rollbar.report_exception(e) if defined?(Rollbar) && !e.is_a?(SystemExit)
  raise
end
```

And then use `capistrano-daemonize` or any `capistrano-foreman` to run it.

## License

MIT
