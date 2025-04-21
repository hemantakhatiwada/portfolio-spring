# ── Stage 1: Build with OpenJDK 24 + Maven ─────────────────────────────
FROM openjdk:24-jdk AS build

# install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# copy pom and download dependencies
COPY pom.xml ./
RUN mvn dependency:go-offline

# copy source and package
COPY src ./src
RUN mvn clean package -DskipTests

# ── Stage 2: Run on a slim JRE 24 image ────────────────────────────────
FROM openjdk:24-jdk-slim

WORKDIR /app

# copy the fat JAR from stage 1
COPY --from=build /app/target/*.jar ./app.jar

# expose Spring Boot’s default port
EXPOSE 8080

# launch the app
ENTRYPOINT ["java", "-jar", "app.jar"]
