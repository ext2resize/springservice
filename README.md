# A basic spring boot service to make a POC of how multi-stage Dockerfiles decrease the size of the image.

FROM openjdk:11-jdk-slim as builder \
WORKDIR /app/source \
COPY . /app/source \ 
RUN ./mvnw clean package \
EXPOSE 8080 \
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

With this ☝️ Dockerfile, the size of the image is ~447MB \
With the Dockerfile of this repo, the size of the image is ~76MB
