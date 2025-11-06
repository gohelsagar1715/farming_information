# Use official Tomcat image with Java 17
FROM tomcat:9.0-jdk17

# Set working directory
WORKDIR /usr/local/tomcat

# Copy built WAR from Ant output
COPY dist/farming_information.war ./webapps/ROOT.war

# Expose Render default port
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
