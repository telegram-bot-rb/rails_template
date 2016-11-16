# Template for tiny Rails app with Telegram bot

Here you can find template for tiny Rails application with Telegram bot.
The repository itself is generated with this template.

What do you get:

- [telegram-bot](https://github.com/telegram-bot-rb/telegram-bot).
- RSpec for tests.
- Pry for debug.
- Simple bot controller.

This is just a template bot and it doesn't have much commands to show.
For more complex example see
[telegram_bot_app](https://github.com/telegram-bot-rb/telegram_bot_app).

For non-Rails app here is
[another example](https://github.com/telegram-bot-rb/telegram-bot/wiki/Non-rails-application).

## Setup

Here is a command to generate smalles possible installation of rails.
Choose yourself what railties to enable:

```
rails new app_name \
  --api \
  --skip-action-mailer \
  --skip-active-record \
  --skip-action-cable \
  --skip-test \
  -m https://raw.githubusercontent.com/telegram-bot-rb/rails_template/master/rails_template.rb
```

## After setup:

- Add this lines to `bin/setup`:
  ```ruby
  puts "\n== Copying sample files =="
  system 'bin/copy_samples'
  ```

- Setup bot config in `config/secrets.yml`.

- Uncomment this line in `spec/rails_helper.rb`:
  ```ruby
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
  ```

- _Optional._ Uncomment default configuration in `spec/spec_helper.rb`.

## Development

    bin/rails telegram:bot:poller

## Deployment

- Edit capistrano config.
- Choose one of deployment ways:

### Receiving webhooks

- Setup domain in `config/environments/production.yml`:
  ```ruby
  config.routes.default_url_options = {host: 'yourdomain.com', protocol: 'https'}
  ```

- Deploy as usual Rails app.

### Poller

This is an easier way, though not the 'right' one.
You can simply run a rake task, or use something like this:

```ruby
# bin/telegram_bot

#!/usr/bin/env ruby

begin
  ENV['BOT_POLLER_MODE'] = 'true'
  require_relative '../config/environment'
  Telegram::Bot::UpdatesPoller.start(ENV['BOT'].try!(:to_sym) || :default)
rescue Exception => e
  Rollbar.report_exception(e) if defined?(Rollbar) && !e.is_a?(SystemExit)
  raise
end
```

And define custom capistrano tasks or something else to run it.

There is sample task to manage such daemon in this repo
at `lib/capistrano/tasks/telegram_bot.rake`.

## License

MIT
