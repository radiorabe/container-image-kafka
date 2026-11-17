FROM quay.io/strimzi/kafka:latest-kafka-4.4.0@sha256:9cd3bf84c2ee57e6261358cc8664a1f1f6e2257a15e32b596dffff8224ee23a3 AS source
FROM ghcr.io/radiorabe/ubi9-minimal:0.12.1@sha256:9a3f83629f9dd656727266b28ceb962824a337c34dab911ff4f0fce75acea642 AS app

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
