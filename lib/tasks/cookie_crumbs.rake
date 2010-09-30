namespace :cookie_crumbs do

  PLUGIN_ROOT = File.dirname(__FILE__) + '/../'

  desc 'Installs required javascript files to the public/javascripts directory.'
  task :install do
    FileUtils.cp Dir[PLUGIN_ROOT + '/javascripts/lib/*.js'], RAILS_ROOT + '/public/javascripts'
  end
end