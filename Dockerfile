ARG target=arm64v8
FROM $target/debian:9.3-slim

ARG arch=aarch64
ENV ARCH=$arch

ARG grafana_version
ENV GRAFANA_VERSION=$grafana_version

ARG grafana_arch=arm64
ENV GRAFANA_ARCH=$grafana_arch

ARG tag
ENV TAG=$tag

# Trick docker build in case qemu binary is not in dir.
COPY .blank tmp/qemu-$ARCH-static* /usr/bin/

RUN apt-get update && apt-get install -qq -y wget tar sqlite && \
    wget -O /tmp/grafana.tar.gz https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-${GRAFANA_ARCH}.tar.gz && \
    tar -zxvf /tmp/grafana.tar.gz -C /tmp && mv /tmp/grafana-$GRAFANA_VERSION /grafana && \
    rm -rf /tmp/grafana.tar.gz

ADD config.ini /grafana/conf/config.ini

RUN        mkdir /data && chmod 777 /data

USER       nobody
EXPOSE     3000
VOLUME     [ "/data" ]
WORKDIR    /grafana/

ENTRYPOINT [ "/grafana/bin/grafana-server" ]

CMD        [ "-config=/grafana/conf/config.ini" ]
