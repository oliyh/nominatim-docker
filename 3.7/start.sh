#!/bin/bash -ex

IMPORT_FINISHED=/var/lib/postgresql/12/main/import-finished

if [ ! -f ${IMPORT_FINISHED} ]; then
  echo "Import has not been completed, would you like to run it?"
  select yn in "Yes" "No"; do
    case $yn in
        Yes ) /app/start2.sh; break;;
        No ) exit;;
    esac
  done
else
  chown -R nominatim:nominatim ${PROJECT_DIR}
  cd ${PROJECT_DIR} && nominatim refresh --website

  service postgresql start
  service apache2 start

  # fork a process and wait for it
  tail -f /var/log/postgresql/postgresql-12-main.log &
  wait
fi
