FROM henryvalle/weblogic

ENV JAVA_OPTIONS="${JAVA_OPTIONS} -Dweblogic.nodemanager.SecureListener=false" \
ADMIN_PORT="7001" \
ADMIN_HOST="localhost"

USER oracle
COPY dockerfiles/keyStore/keystore_ss.jks /u01/oracle/keystore/
COPY dockerfiles/patch/* /u01/oracle/patch/
COPY dockerfiles/local_domainScripts /u01/oracle/local_domainScripts/
COPY dockerfiles/scripts/* /u01/oracle/
COPY dockerfiles/applicationFiles/ /u01/oracle/applicationFiles/

USER root
RUN yum install -y procps
RUN chmod +x startWeblogic.sh

USER oracle

RUN /u01/oracle/wlst /u01/oracle/local_domainScripts/config.py

RUN nohup bash -c "/u01/oracle/user_projects/domains/local_domain/bin/startNodeManager.sh &" && sleep 4

CMD ["/u01/oracle/user_projects/domains/local_domain/startWebLogic.sh"]
