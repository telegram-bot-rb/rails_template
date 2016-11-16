class TelegramWebhooksController < Telegram::Bot::UpdatesController
  def start(*)
    respond_with :message, text: t('.hi')
  end
end
