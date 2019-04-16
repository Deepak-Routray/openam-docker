#!/usr/bin/env bash
set -euo pipefail

# Instance dir does not exist? Then we need to run setup
if [ ! -f ${BASE_DIR}/install.log ] ; then
  echo "OpenAM config not found. Configuring.."
  chown root:root -R $BASE_DIR
  /data/configure.sh &
fi

echo "Starting the server"
export CATALINA_OPTS="-Xmx$MAX_HEAP -server -Dcom.iplanet.services.configpath=$BASE_DIR -Dcom.sun.identity.configuration.directory=$BASE_DIR"

${CATALINA_HOME}/bin/catalina.sh run
