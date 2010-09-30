require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")

$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__) + '/../../activesupport/lib/active_support')


require 'yaml'
require 'test/unit'
require 'action_controller'

require 'action_controller/test_process'

ActionController::Base.logger = nil
ActionController::Routing::Routes.reload rescue nil