$LOAD_PATH.unshift(File.expand_path('../..', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))

require 'acmscw'
require 'spec'
require 'spec/autorun'
::Waw::autoload(__FILE__)