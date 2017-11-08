logger.level = Logger::MAX_LEVEL

set :application, "bobo"

# Stages Configuration
set :stages,        %w(production preproduction developement)
set :default_stage, "preproduction"
set :stage_dir,     "app/config/deploy_stages"
require 'capistrano/ext/multistage'

# Common configuration
ssh_options[:port] = 2676
ssh_options[:forward_agent] = true
set :app_path,       "app"
set :cache_warmup,   false
set :repository,    "git@github.com:apimobi/bobo.git"
set :scm,           :git
set :model_manager, "doctrine"
set :keep_releases,  3
set :dump_assetic_assets, false

set :writable_dirs,       ["var/cache", "var/logs"]
set :shared_children,     [web_path + "/uploads"]
set :permission_method,   :chown
set :use_set_permissions, true
set :shared_files,      ["app/config/parameters.yml"]
set :symfony_console, "bin/console"


# Useful instead of editing visudo
default_run_options[:pty] = true

# Events
before "symfony:composer:install", "bobo:npm"
after "symfony:composer:install", "bobo:rights"
after "deploy:update", "deploy:cleanup"

# Tasks in bobo namespace
namespace :bobo do
    task :npm do
        capifony_pretty_print "--> Npm install :)"
        run "cd #{latest_release} && npm install"
        capifony_puts_ok
    end
    task :rights do
        capifony_pretty_print "--> Folders Rights"
        #run "sudo chmod -R 777 #{latest_release}/var/cache"
        #run "sudo chmod -R 777 #{latest_release}/var/logs"
        #run "sudo chown -R www-data:www-data #{latest_release}/var/cache"
        #run "sudo chown -R www-data:www-data #{latest_release}/var/logs"
        #run "sudo rm -rf #{latest_release}/var/cache/*"
    end
end
