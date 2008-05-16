# Install hook code here

require 'ftools'

plugins_dir = File.expand_path(".")
crumbs_dir = File.join(plugins_dir, 'cookie_crumbs')
root_dir = File.join(crumbs_dir, '..', '..', '..')

File.copy File.join(crumbs_dir, 'javascripts', 'lib', 'cookie_crumbs.js'), File.join(root_dir, 'public', 'javascripts', 'cookie_crumbs.js')