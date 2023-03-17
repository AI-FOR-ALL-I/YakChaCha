FROM openjdk:11-jdk-slim

ARG JAR_FILE=build/libs/*SNAPSHOT.jar

COPY ${JAR_FILE} app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
