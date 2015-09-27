# rackup config.ru
#
$LOAD_PATH.unshift(File.expand_path('../../../lib/application', __FILE__))

require ::File.expand_path('../lib/application/app',  __FILE__)

run SeoTools::Application
