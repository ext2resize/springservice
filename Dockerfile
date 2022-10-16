FROM alpine:latest as packager

RUN apk --no-cache add openjdk11-jdk openjdk11-jmods

ENV JAVA_MINIMAL="/opt/java-minimal"

RUN /usr/lib/jvm/java-11-openjdk/bin/jlink \
    --verbose \
    --add-modules \
        java.base,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument \
    --compress 2 --strip-debug --no-header-files --no-man-pages \
    --release-info="add:IMPLEMENTOR=Gnoppix:IMPLEMENTOR_VERSION=Gnoppix_JRE" \
    --output "$JAVA_MINIMAL"

RUN mkdir -p /app/source
WORKDIR /app/source
COPY . /app/source
RUN ./mvnw clean package

FROM alpine:latest

ENV JAVA_HOME=/opt/java-minimal
ENV PATH="$PATH:$JAVA_HOME/bin"

COPY --from=packager "$JAVA_HOME" "$JAVA_HOME"
COPY --from=packager "/app/source/target/*.jar" "/app/app.jar"

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
