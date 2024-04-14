FROM quay.io/strimzi/kafka:latest-kafka-3.7.0 AS source
FROM ghcr.io/radiorabe/ubi9-minimal:0.6.8 AS app

COPY --from=source /opt /opt

ENV JAVA_VERSION=17
ENV JAVA_HOME=/usr/lib/jvm/jre-17
ENV KAFKA_HOME=/opt/kafka
ENV PATH=/opt/kafka/bin:${PATH}

WORKDIR /opt/kafka

RUN    microdnf install -y \
         shadow-utils \
         hostname \
         java-${JAVA_VERSION}-openjdk-headless \
    && useradd -u 1001 -r -g 0 -s /sbin/nologin \
         -c "Default Application User" default \
    && microdnf remove -y \
         libsemanage \
         shadow-utils \
    && microdnf clean all \
    && sed \
         --in-place \
         --expression='s/log4j.rootLogger=INFO, stdout, kafkaAppender/log4j.rootLogger=INFO, stdout/' \
         config/log4j.properties \
    && sed \
         --in-place \
         --expression='s/log4j.rootLogger=INFO, stdout, connectAppender/log4j.rootLogger=INFO, stdout/' \
         config/connect-log4j.properties

VOLUME /tmp/kraft-combined-logs
VOLUME /tmp/kafka-logs
USER 1001
