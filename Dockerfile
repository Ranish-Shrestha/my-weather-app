# Use the official Maven image to build the application
FROM maven:3.8.4-openjdk-17 as BUILD

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Use a smaller base image to run the application
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the executable JAR file into the container
COPY --from=build /app/target/my_weather_app-0.0.1-SNAPSHOT.jar my_weather_app.jar

# Expose the application port
EXPOSE 8080

# Specify the command to run the JAR file
ENTRYPOINT ["java", "-jar", "my_weather_app.jar"]