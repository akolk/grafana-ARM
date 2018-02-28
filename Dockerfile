ARG target=arm64v8
FROM $target/debian:9.3-slim

ARG arch=aarch64
ENV ARCH=$arch
ARG GRAFANA_VERSION
ARG TAG

# Trick docker build in case qemu binary is not in dir.
COPY .blank tmp/qemu-$ARCH-static* /usr/bin/

ADD $TAG/grafana-$GRAFANA_VERSION.tar.gz /tmp/

RUN apt-get update && apt-get install -qq -y wget tar sqlite && \
    mv /tmp/grafana-$GRAFANA_VERSION /grafana

ADD config.ini /grafana/conf/config.ini

USER       nobody
EXPOSE     3000
VOLUME     [ "/data" ]
WORKDIR    /grafana
ENTRYPOINT [ "/grafana/bin/grafana-server" ]
CMD        [ "-config=/grafana/conf/config.ini" ]