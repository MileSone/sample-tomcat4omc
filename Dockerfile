FROM tomcat:8.0-alpine
LABEL maintainer="deepak@softwareyoga.com"

ADD sample.war /usr/local/tomcat/webapps/

WORKDIR /app/omc-sample-app/omc/
RUN ls
RUN mkdir omc-sample-app
RUN mkdir omc-sample-app/omc
ADD /omc-sample-app/1.53_APM_226.zip /app/omc-sample-app/omc
ADD /omc-sample-app/registrationKey.txt /app/omc-sample-app/omc
RUN unzip /app/omc-sample-app/omc/1.53_APM_226.zip -d /app/omc-sample-app/omc
RUN unzip /app/omc-sample-app/omc/ApmAgent-1.53.zip -d /app/omc-sample-app/omc
RUN pwd
RUN /bin/bash ProvisionApmJavaAsAgent.sh -d /app/omc-sample-app/omc/ -h do-not-use -no-wallet -no-prompt -regkey-file registrationKey.txt
ENV APM_PROP_FILE=/app/omc-sample-app/omc/apmagent/config/AgentStartup.properties
RUN echo "oracle.apmaas.agent.appServer.classifications=OMC_SAMPLE" >> ${APM_PROP_FILE}
ENV JAVA_OPTS="-javaagent:/app/omc-sample-app/omc/apmagent/lib/system/ApmAgentInstrumentation.jar"

EXPOSE 8080
CMD ["catalina.sh", "run"]