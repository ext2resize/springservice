# A basic spring boot service to make a POC of how multi-stage Dockerfiles can reduce the size of the image.
```
FROM openjdk:11-jdk-slim
WORKDIR /app/source
COPY . /app/source
RUN ./mvnw clean package
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
```
With this ☝️ Dockerfile, the size of the image is ~447MB \
With the [Dockerfile](https://github.com/alican-uzun/springservice/blob/master/Dockerfile "Dockerfile") of this repo, the size of the image is ~76MB
