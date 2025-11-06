FROM eclipse-temurin:17-jdk

# Use safe mirrors and handle network issues
RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list

RUN apt-get clean && apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true && \
    apt-get install -y wget ant unzip curl && \
    rm -rf /var/lib/apt/lists/*

# Download Tomcat with retry mechanism
RUN mkdir -p /opt && \
    (wget --tries=3 --timeout=30 https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.92/bin/apache-tomcat-9.0.92.zip \
     || wget --tries=3 --timeout=30 https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.92/bin/apache-tomcat-9.0.92.zip) && \
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
