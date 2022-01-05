FROM node:14-bullseye
LABEL authors="john.lin<john.lin@ringcentral.com>"

ENV VERSION_PJSIP=2.11.1

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
            build-essential \
            ca-certificates \
            curl \
            libgsm1-dev \
            libspeex-dev \
            libspeexdsp-dev \
            libsrtp0-dev \
            libssl-dev \
            portaudio19-dev \
            && \
    apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/*

COPY config_site.h /tmp/

RUN cd /opt && \
    wget -qnv "https://github.com/pjsip/pjproject/archive/$VERSION_PJSIP.tar.gz" -O - | tar zxvf - && \
    cd /opt/pjproject-$VERSION_PJSIP && \
    mv /tmp/config_site.h pjlib/include/pj/ && \
    \
    ./configure CFLAGS="-O2 -fPIC" \
                --prefix=/usr \
                && \
    make all install && \
    /sbin/ldconfig && \
    rm -rf /opt/pjproject-$VERSION_PJSIP