#!/usr/bin/env bash
set -euo pipefail

until curl -Is http://localhost:8080/openam/config/options.htm | head -n 1 | grep "200 OK" >/dev/null; do
  echo "Waiting for complete startup OpenAM"
  sleep 5
done

#Configure OpenAM
cd /home/openam/conf
cp /files/initial-config.properties .
echo "server is started!! Running configurator tool"
java -jar openam-configurator-tool-${OPENAM_VERSION}.jar --file initial-config.properties -DSERVER_URL=http://localhost:8080

sleep 5
#Create a default user (Not amadmin)
if [ ! -z "$APP_USER" ] && [ ! -z "$APP_USER_PWD" ] ; then
  cd /home/openam/admintools
  # password file should be readonly for the owning user
  echo "${AM_PWD}" > mypass
  chmod 400 mypass
  chmod +x setup
  echo "setup"
  ./setup --acceptLicense -p $BASE_DIR
  echo "setup done"

  if [ -d openam/bin/ ] ; then
	cd openam/bin/
	chmod +x ssoadm
	echo "create-identity"
	./ssoadm create-identity -e / -i ${APP_USER} -t User -u amadmin -f ../../mypass -a givenName=${APP_USER} sn=${APP_USER} userPassword=${APP_USER_PWD}
	echo "create-identity done"
  fi
fi
cd /usr/local/tomcat
