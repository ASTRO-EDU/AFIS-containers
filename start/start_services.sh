  if [ ! -d /var/lib/mysql/mysql ]; then
      echo "Initializing mysqld"
      mysqld --initialize  --init-file=/opt/conf/init_db_script
      # remove init_db_script
  fi

  # launch mysqld
  echo "Start mysqld"
  #mysqld --secure-file-priv=NULL &
  mysqld --port 60306 &

  # launch apache
  echo "Start apache"
  /usr/sbin/httpd &

  echo "Start munged"
  munged -f
  sleep 3
  echo "Start slurmdbd"
  slurmdbd
  sleep 3
  echo "Start slurmctld"
  slurmctld
  sleep 3
  echo "Start slurmd"
  slurmd

