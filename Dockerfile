# ── Stage 1: Build with Maven ────────────────────────────
FROM maven:3.9.2-openjdk-17 AS build
WORKDIR /app

# copy Maven config and source files
COPY pom.xml .
COPY src ./src

# build the project, skipping tests to save time
RUN mvn clean package -DskipTests

# ── Stage 2: Run with a slim JDK image ─────────────────
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# copy the fat JAR from the build stage (Stage 1)
COPY --from=build /app/target/portfolio-1.0.0.jar ./portfolio.jar

# expose the default Spring Boot port (8080)
EXPOSE 8080

# run the app
ENTRYPOINT ["java", "-jar", "portfolio.jar"]
