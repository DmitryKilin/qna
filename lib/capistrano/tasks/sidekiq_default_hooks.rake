namespace :sidekiq do
  Rake::Task["add_default_hooks"].clear
  task :add_default_hooks do
    #after 'deploy:starting',  'sidekiq:quiet'
    after 'deploy:updated',   'sidekiq:stop'
    after 'deploy:published', 'sidekiq:start'
    after 'deploy:failed', 'sidekiq:restart'
  end
end