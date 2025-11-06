FROM eclipse-temurin:17-jdk

# Install basic tools
RUN apt-get update && apt-get install -y wget ant unzip && rm -rf /var/lib/apt/lists/*

# Download Tomcat (from archive, since the latest version link moves)
RUN mkdir -p /opt && \
    wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.82/bin/apache-tomcat-9.0.82.zip && \
    unzip apache-tomcat-9.0.82.zip -d /opt && \
    mv /opt/apache-tomcat-9.0.82 /opt/tomcat && \
    rm apache-tomcat-9.0.82.zip

# Set environment variables
ENV CATALINA_HOME=/opt/tomcat
ENV PATH="$CATALINA_HOME/bin:$PATH"

WORKDIR /app
COPY . /app

# Build the WAR file
RUN ant clean dist || true

# Copy WAR to Tomcat webapps
RUN cp dist/*.war $CATALINA_HOME/webapps/ROOT.war || true

EXPOSE 8080
CMD ["catalina.sh", "run"]
