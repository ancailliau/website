# 
# If you are an happy guy, executing this file will do the job, otherwise
# read on!
#
# Requirements:
#   ruby >= 1.8.6
#   postgresql >= 8.3
#
# Meeting those requirements is behind the scope of this INSTALL file

# Gems (see vendor folder)
#   json >= 1.1.9  (sudo gem install sequel, for the last version)
#   sequel >= 3.8  (sudo gem install sequel, for the last version)
#   rack >= 1.1.0 (sudo gem install rack, for the last version)
#   wlang >= 0.8.4 (or see http://github.com/blambeau/wlang for the last version)
#   waw >= 0.1.0 (or see http://github.com/blambeau/waw for the last version)
#
# To install those gems, type the following commands
echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
echo 'If a password is prompted, it is the one for sudo'
echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

echo 'Installing required ruby gems'
sudo gem install --no-rdoc --no-ri vendor/json-1.1.9.gem
sudo gem install --no-rdoc --no-ri vendor/sequel-3.8.0.gem
sudo gem install --no-rdoc --no-ri vendor/rack-1.1.0.gem
sudo gem install --no-rdoc --no-ri vendor/wlang-0.8.5.gem
sudo gem install --no-rdoc --no-ri vendor/waw-0.1.2.gem

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
echo 'the acmscw database user'
echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
sudo su postgres -c 'createuser --superuser --createdb --login --pwprompt acmscw'
sudo su postgres -c 'createdb --owner acmscw --encoding utf8 acmscw'
ruby -Ilib lib/acmscw/state/migrate_v2.rb

# You can now start the web application using the following command
echo ''
echo 'Hey hey everything fine :-), we lauch the webserver now'
echo 'Have a look at http://127.0.0.1:9292/'
./config.ru
