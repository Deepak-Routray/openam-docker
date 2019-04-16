FROM tomcat:8.5-jre8

ENV CATALINA_HOME /usr/local/tomcat

ENV PATH $CATALINA_HOME/bin:$PATH

WORKDIR $CATALINA_HOME

ENV BASE_DIR="/openam"
ENV CONFIG_DIR="/usr/openam"
ENV VERSION 14.2.2
ENV MAX_HEAP="2g"

RUN apt-get install -y wget unzip

RUN wget --show-progress --progress=bar:force:noscroll --quiet https://github.com/OpenIdentityPlatform/OpenAM/releases/download/$VERSION/OpenAM-$VERSION.war

RUN mv *.war $CATALINA_HOME/webapps/openam.war

RUN mkdir $CONFIG_DIR

RUN wget --show-progress --progress=bar:force:noscroll --quiet --output-document=$CONFIG_DIR/ssoconfiguratortools.zip https://github.com/OpenIdentityPlatform/OpenAM/releases/download/$VERSION/SSOConfiguratorTools-$VERSION.zip \
 && unzip $CONFIG_DIR/ssoconfiguratortools.zip -d $CONFIG_DIR/ssoconfiguratortools \
 && rm $CONFIG_DIR/ssoconfiguratortools.zip

RUN wget --show-progress --progress=bar:force:noscroll --quiet --output-document=$CONFIG_DIR/ssoadmintools.zip https://github.com/OpenIdentityPlatform/OpenAM/releases/download/$VERSION/SSOAdminTools-$VERSION.zip \
 && unzip $CONFIG_DIR/ssoadmintools.zip -d $CONFIG_DIR/ssoadmintools \
 && rm $CONFIG_DIR/ssoadmintools.zip

COPY data/run_me.sh /data/
COPY data/configure.sh /data/
RUN chmod 777 /data/run_me.sh
RUN chmod 777 /data/configure.sh

RUN sed -i -e 's/\r$//' /data/run_me.sh
RUN sed -i -e 's/\r$//' /data/configure.sh
ENTRYPOINT ["/bin/bash","-c","/data/run_me.sh"]
