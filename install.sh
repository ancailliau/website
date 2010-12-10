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

#
# We force a sudo password prompt
#
echo "Please provide a sudo password for further commands:"
sudo -v

# Gems (see vendor folder)
#   fastercsv >= 1.5.1  (sudo gem install fastercsv, for the latest version)
#   json >= 1.1.9  (sudo gem install json, for the latest version)
#   pg >= 0.8.0 (sudo gem install pg, for the latest version)
#   rack >= 1.1.0 (sudo gem install rack, for the latest version)
#   rdoc >= 2.4.1 (sudo gem install rdoc, for the latest version)
#   sequel >= 3.8  (sudo gem install sequel, for the latest version)
#   wlang >= 0.9.0 (or see http://github.com/blambeau/wlang for the latest version)
#   waw >= 0.2.0 (or see http://github.com/blambeau/waw for the latest version)
#   dbagile >= 0.0.1 (or see http://github.com/blambeau/dbagile for the latest version)
#
# To install those gems, type the following commands
echo 'Installing required ruby gems'
sudo gem install --no-rdoc --no-ri vendor/fastercsv-1.5.1.gem
sudo gem install --no-rdoc --no-ri vendor/json-1.1.9.gem
sudo gem install --no-rdoc --no-ri vendor/pg-0.8.0.gem
sudo gem install --no-rdoc --no-ri vendor/rack-1.2.1.gem
sudo gem install --no-rdoc --no-ri vendor/rdoc-2.4.1.gem
sudo gem install --no-rdoc --no-ri vendor/sequel-3.8.0.gem
sudo gem install --no-rdoc --no-ri vendor/wlang-0.9.0.gem
sudo gem install --no-rdoc --no-ri vendor/waw-0.3.0.gem
sudo gem install --no-rdoc --no-ri vendor/dbagile-0.0.1.gem

#
# The code expects an 'acmscw' postgresql database, accessible through an 
# 'acmscw' user, already created as well. See config/acmscw.cfg.example for 
# changing these parameters. 
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
sudo su postgres -c 'createuser --superuser --createdb --login --pwprompt acmscw'
sudo su postgres -c 'createdb --owner acmscw --encoding utf8 acmscw'
sudo su postgres -c 'psql -U acmscw acmscw < model/snapshots/20101210-0940.sql'

cp model/dbagile-example.idx model/dbagile.idx
mkdir model/devel
dba --repository=model schema:dump announced > model/devel/effective.yaml
dba --repository=model db:stage

# You can now start the web application using the following command
echo ''
echo 'Hey hey everything fine :-), we lauch the webserver now'
echo 'Have a look at http://127.0.0.1:9292/'
waw-start
