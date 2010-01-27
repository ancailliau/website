set -e
# 
# If you are an happy guy, executing this file will do the job, otherwise
# read on!
#
# Requirements:
#   Ruby >= 1.8.6, with C++ headers
#   Rubygems >= 1.3.5
#   Postgresql >= 8.3, with C++ headers
#
# Meeting those requirements is behind the scope of this INSTALL file

# Gems (see vendor folder)
#   json >= 1.1.9  (sudo gem install json, for the last version)
#   sequel >= 3.8  (sudo gem install sequel, for the last version)
#   rack >= 1.1.0 (sudo gem install rack, for the last version)
#   wlang >= 0.9.0 (or see http://github.com/blambeau/wlang for the last version)
#   waw >= 0.2.0 (or see http://github.com/blambeau/waw for the last version)
#
# To install those gems, type the following commands
echo 'Installing required ruby gems'
gem install --no-rdoc --no-ri vendor/json-1.1.9.gem
gem install --no-rdoc --no-ri vendor/sequel-3.8.0.gem
gem install --no-rdoc --no-ri vendor/rack-1.1.0.gem
gem install --no-rdoc --no-ri vendor/wlang-0.9.0.gem
gem install --no-rdoc --no-ri vendor/waw-0.2.0.gem

#
# The code expects an 'acmscw' postgresql database, accessible through an 
# 'acmscw' user, already created as well. See config/yemana.cfg for changing
# those parameters. 
#
# To install the database from scratch, execute the following commands in your 
# shell
#
echo ''
echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
echo 'Installing postgresql database now...'
echo 'If a password is prompted, it is the one used for'
echo 'the acmscw database user (see your config file)'
echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
su postgres -c 'createuser --superuser --createdb --login --pwprompt acmscw'
su postgres -c 'createdb --owner acmscw --encoding utf8 acmscw'
ruby -Ilib lib/acmscw/state/migrate_v2.rb

# You can now start the web application using the following command
echo ''
echo 'Hey hey everything fine :-), we lauch the webserver now'
echo 'Have a look at http://127.0.0.1:9292/'
./config.ru
