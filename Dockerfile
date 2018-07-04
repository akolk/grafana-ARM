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
    wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_${GRAFANA_VERSION}_${GRAFANA_ARCH}.deb && \
    apt install grafana_${GRAFANA_VERSION}_${GRAFANA_ARCH}.deb

ADD config.ini /grafana/conf/config.ini

USER       nobody
EXPOSE     3000
VOLUME     [ "/data" ]
WORKDIR    /grafana
ENTRYPOINT [ "/grafana/bin/grafana-server" ]
CMD        [ "-config=/grafana/conf/config.ini" ]
