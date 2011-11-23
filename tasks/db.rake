namespace :db do

  task :sudo do
    puts "Please provide a sudo password for further commands:"
    puts `sudo -v`
  end

  task :install => :sudo do
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    puts 'Installing postgresql database now...'
    puts 'If a password is prompted, it is the one used for'
    puts 'the acmscw database user (see your config file)'
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    puts `sudo su postgres -c 'dropdb acmscw'`
    puts `sudo su postgres -c 'dropuser acmscw'`
    puts `sudo su postgres -c 'createuser --createdb --login --pwprompt acmscw'`
    puts `sudo su postgres -c 'createdb --owner acmscw --encoding utf8 acmscw'`

    if snapshot = Dir["model/snapshots/*.sql"].sort.last
      puts "Installing snapshot #{snapshot}"
      puts `sudo su postgres -c 'psql -U acmscw acmscw < #{snapshot}'`
    else
      "No database snapshot found, please check manually"
    end

    puts `cp model/dbagile-example.idx model/dbagile.idx`
    puts `mkdir model/devel`
    puts `dba --repository=model schema:dump announced > model/devel/effective.yaml`
    puts `dba --repository=model db:use devel`
  end

  task :stage do
    puts `dba --repository=model db:stage`
  end

  task :snapshot do
    require 'time'
    require 'fileutils'
    snapshot_name = Time.now.strftime('%Y%m%d-%H%M')
    snapshot_dir  = "model/snapshots"
    snapshot_file = File.join(snapshot_dir, "#{snapshot_name}.sql")
    puts `pg_dump -U acmscw --inserts --file=#{snapshot_file} acmscw`  
  end

end
