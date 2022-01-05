FROM node:14-alpine
LABEL authors="john.lin<john.lin@ringcentral.com>"

ENV NODE_CONTAINER=docker
ENV VERSION_PJSIP=2.8

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

#========================
# Install bash and ca-certificates
#========================
RUN apk update && apk upgrade \
    && apk add --no-cache ca-certificates bash git python-dev py-pip gcc g++\
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
    && ./configure CFLAGS='-O2 -fPIC' \
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
# https://github.com/Zenika/alpine-chrome/blob/master/Dockerfile
#========================
# Installs latest Chromium package.
RUN apk update \
    && apk add --no-cache \
    libstdc++ \
    chromium \
    harfbuzz \
    nss \
    freetype \
    freetype-dev \
    ttf-freefont \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Autorun chrome headless
ENTRYPOINT ["chromium-browser", "--headless", "--use-gl=swiftshader", "--disable-software-rasterizer", "--disable-dev-shm-usage"]