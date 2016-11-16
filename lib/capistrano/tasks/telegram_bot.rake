namespace :telegram do
  namespace :bot do
    namespace :poller do
      {
        start:         'start an instance of the application',
        stop:          'stop all instances of the application',
        restart:       'stop all instances and restart them afterwards',
        reload:        'send a SIGHUP to all instances of the application',
        # run:           'start the application and stay on top',
        zap:           'set the application to a stopped state',
        status:        'show status (PID) of application instances',
      }.each do |action, description|
        desc description
        task action do
          on roles(:app) do
            within current_path do
              with rails_env: fetch(:rails_env) do
                execute :bundle, :exec, 'bin/telegram_bot_ctl', action
              end
            end
          end
        end
      end
    end
  end
end

after 'deploy:finished', 'telegram:bot:poller:restart'
