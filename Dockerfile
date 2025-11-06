FROM eclipse-temurin:17-jdk

RUN apt-get update && \
    apt-get install -y wget ant unzip && \
    wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.92/bin/apache-tomcat-9.0.92.zip && \
    unzip apache-tomcat-9.0.92.zip -d /opt && \
    mv /opt/apache-tomcat-9.0.92 /opt/tomcat && \
    rm apache-tomcat-9.0.92.zip

ENV CATALINA_HOME=/opt/tomcat
ENV PATH="$CATALINA_HOME/bin:$PATH"
WORKDIR /app

COPY . /app

RUN ant clean dist || true

RUN cp dist/*.war $CATALINA_HOME/webapps/ROOT.war || true

EXPOSE 8080

CMD ["catalina.sh", "run"]
