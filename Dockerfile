# ---------- Build Stage ----------
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set working directory inside the build container
WORKDIR /todoapp

# Copy project files
COPY pom.xml .
COPY src ./src

# Build the project (skip tests to speed up Docker build)
RUN mvn clean package -DskipTests


# ---------- Run Stage ----------
FROM eclipse-temurin:17-alpine

# Set working directory inside the runtime container
WORKDIR /todoapp

# Copy the JAR from the build container
COPY --from=build /todoapp/target/*.jar app.jar

# Expose the app port
EXPOSE 8090

# Run the JAR
ENTRYPOINT ["java", "-jar", "app.jar"]
