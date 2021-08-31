FROM maven:3-jdk-8-alpine
ARG MAVEN_REGISTRY="https://maven.aliyun.com/repository/central"
RUN echo "<settings xmlns=\"http://maven.apache.org/SETTINGS/1.0.0\" \
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \
xsi:schemaLocation=\"http://maven.apache.org/SETTINGS/1.0.0 \
                    https://maven.apache.org/xsd/settings-1.0.0.xsd\"> \
<localRepository>/usr/share/maven/ref/repository</localRepository> \
<mirrors> \
    <mirror> \
        <id>local</id> \
        <name>central</name> \
        <url>"$MAVEN_REGISTRY"</url> \
        <mirrorOf>external:*</mirrorOf> \
    </mirror> \
</mirrors> \
</settings>" > /usr/share/maven/conf/settings.xml
WORKDIR /app

COPY pom.xml ./pom.xml
RUN mvn package -Dmaven.test.skip=true
COPY src ./src
RUN mvn package -Dmaven.test.skip=true

ARG JAR_FILE=target/thin/root/*.jar
RUN mv $JAR_FILE app.jar

FROM openjdk:8-jre-alpine
ENV TZ=Asia/Shanghai
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone
WORKDIR /app

COPY --from=0 /app/target/thin /app/thin
COPY --from=0 /app/app.jar ./app.jar
RUN cp /app/app.jar /app/thin/root/app.jar

ENTRYPOINT ["java","-Dthin.root=/app/thin/root","-jar","/app/app.jar"]
