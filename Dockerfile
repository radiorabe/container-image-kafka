FROM quay.io/strimzi/kafka:latest-kafka-4.3.0@sha256:8f4024bbf0382404bc1786666d6cebcbb3279b14766db860d2f07ea93f21d21e AS source
FROM ghcr.io/radiorabe/ubi9-minimal:0.12.0@sha256:ddf3ac33c48b5005cc325732cb547279a926f29b3db9adcbd844f1cf94dcf831 AS app

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
    && microdnf clean all

VOLUME /opt/kafka/logs
USER 1001
