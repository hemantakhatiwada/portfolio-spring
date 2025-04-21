# ── Stage 1: Build with JDK 24 (Debian-based) and Maven ───────────────
FROM eclipse-temurin:24-jdk AS build

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml ./
RUN mvn dependency:go-offline

# Copy source and package
COPY src ./src
RUN mvn clean package -Dmaven.test.skip=true


# ── Stage 2: Run with JDK 24 slim ──────────────────────────────────────
FROM eclipse-temurin:24-jdk-alpine

WORKDIR /app

COPY --from=build /app/target/*.jar ./app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
