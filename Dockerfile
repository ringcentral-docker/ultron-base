FROM node:12-alpine
LABEL authors="john.lin<john.lin@ringcentral.com>"

ENV NODE_CONTAINER=docker

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV VERSION_PJSIP 2.10
ENV VERSION_CHROMIUM 80
#========================
# Add edge into repositories
#========================
RUN echo @edge http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories \
    && echo @edge http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories

#========================
# Install bash and ca-certificates
#========================
RUN apk update && apk upgrade \
    && apk add --no-cache ca-certificates bash git python2-dev py-pip gcc g++\
    && pip install numpy==1.16.5 \
    && pip install pandas==0.23.4 \
    && pip install requests \
    && pip install socketIO_client \
    && rm -rf /var/cache/apk/*

#========================
# Install pjsua
# https://github.com/minoruta/pjsip-node-alpine/blob/master/Dockerfile
#========================
RUN apk add --no-cache --virtual .build4pjsip \
    alpine-sdk \
    && apk add --no-cache \
    libsrtp-dev \
    openssl-dev \
    opus-dev \
    && cd /opt \
    && wget -qnv "https://github.com/pjsip/pjproject/archive/$VERSION_PJSIP.tar.gz" -O - | tar zxvf - \
    && cd /opt/pjproject-$VERSION_PJSIP \
    && ./configure CFLAGS='-O3 -DNDEBUG -msoft-float -fno-builtin' \
    && make dep \
    && make \
    && make install \
    && cd /opt/pjproject-$VERSION_PJSIP/pjsip-apps/src/python \
    && python ./setup.py install \
    && cd /opt \
    && rm -rf pjproject-$VERSION_PJSIP \
    && apk del .build4pjsip

#========================
# Installs latest Chromium package.
# https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md
#========================
RUN apk update && apk upgrade && \
    apk add --no-cache \
      chromium@edge~=${VERSION_CHROMIUM} \
      nss@edge \
      freetype@edge \
      freetype-dev@edge \
      harfbuzz@edge \
      ttf-freefont@edge

