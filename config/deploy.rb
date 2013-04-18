# c.f https://gist.github.com/wlangstroth/3740923

set :application, "smoothie"
set :repository,  "git://github.com/MrRuru/smoothie.git"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set  :host, 'smoothie.fm'
role :web, host                          # Your HTTP server, Apache/etc
role :app, host                          # This may be the same as your `Web` server

set :rack_env, :production
set :user, 'ec2-user'

set :use_sudo, false

set :deploy_to, "/srv/#{application}"
# set :unicorn_conf, "#{current_path}/config/unicorn.rb"
# set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"


after "deploy:create_symlink", "deploy:assets"

namespace :deploy do
 
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{current_path} && bundle exec unicorn -c #{unicorn_conf} -E #{rack_env} -D; fi"
  end
 
  task :start do
    run "cd #{current_path} && bundle exec unicorn -c #{unicorn_conf} -E #{rack_env} -D"
  end
 
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end

  # TODO : symlink

  # TODO : assets
  task :assets do
    puts "Compiling assets"
    run "cd #{release_path} && bundle exec rake assetpack:build"    
  end
   
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end