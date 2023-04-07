FROM gradle:jdk11 as builder

ENV APP_HOME=/apps

WORKDIR $APP_HOME

COPY build.gradle settings.gradle $APP_HOME/

COPY src $APP_HOME/src

ENV SPRING_PROFILES_ACTIVE=dev

RUN gradle clean build

FROM openjdk:11-jdk

ENV APP_HOME=/apps
ARG ARTIFACT_NAME=app.jar
ARG JAR_FILE_PATH=build/libs/ycc-0.0.1-SNAPSHOT.jar

WORKDIR $APP_HOME
COPY --from=builder $APP_HOME/$JAR_FILE_PATH $ARTIFACT_NAME

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=dev

ENTRYPOINT ["java", "-jar", "app.jar"]
