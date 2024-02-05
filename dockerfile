FROM maven:3.8.4-openjdk-11-slim AS build-stage

# Set the working directory inside the container
WORKDIR /Repo4

# Copy the maven project definition files
COPY pom.xml ./

# Download the dependencies needed for the build (cached them in a seperate layer)
RUN mvn dependency:go-offline

# Copy the application source code
COPY src ./src

# Build the WAR file
RUN mvn package

# Stage 2: Production stage
FROM tomcat:8.5.78-jdk11-openjdk-slim

# Copy the Built war file from the build stage to the Tomcat webapps directory
COPY --from=build-stage /Repo4/target/*.war /usr/local/tomcat/webapps

# Expose the port on which Tomcat will listen (usually port 8080)
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh" "run"]