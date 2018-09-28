#!/usr/bin/env bash
set -euo pipefail

# Instance dir does not exist? Then we need to run setup
if [ ! -f ${BASE_DIR}/install.log ] ; then
  echo "OpenAM config not found. Configuring.."
  chown root:root -R $BASE_DIR
  /data/configure.sh &
fi

echo "Starting the server"
sed -i '3i JAVA_OPTS="$JAVA_OPTS -server -Xmx$MAX_HEAP -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=256m  -Dcom.sun.identity.configuration.directory=${BASE_DIR}"' ${CATALINA_HOME}/bin/catalina.sh
${CATALINA_HOME}/bin/catalina.sh run