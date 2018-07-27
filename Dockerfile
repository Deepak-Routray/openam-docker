FROM wdijkerman/openam:13.0.0

USER 0:0

ENV MAX_HEAP="1g"

RUN rm -rf /openam
COPY data/run_me.sh /data/
COPY data/configure.sh /data/
RUN chmod 777 /data/run_me.sh
RUN chmod 777 /data/configure.sh

RUN sed -i -e 's/\r$//' /data/run_me.sh
RUN sed -i -e 's/\r$//' /data/configure.sh
ENTRYPOINT ["/bin/bash","-c","/data/run_me.sh"]
