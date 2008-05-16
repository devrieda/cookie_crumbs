require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")

$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__) + '/../../activesupport/lib/active_support')


require 'yaml'
require 'test/unit'
require 'action_controller'
require 'breakpoint'

require 'action_controller/test_process'

ActionController::Base.logger = nil
ActionController::Base.ignore_missing_templates = false
ActionController::Routing::Routes.reload rescue nil