FROM public.ecr.aws/docker/library/node:16.10.0-buster
LABEL authors="john.lin<john.lin@ringcentral.com>"

ENV VERSION_PJSIP=2.12

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
            build-essential \
            ca-certificates \
            binutils \
            pulseaudio \
            python3-dev \
            && \
    apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/*

RUN cd /opt && \
    wget -qnv "https://github.com/pjsip/pjproject/archive/$VERSION_PJSIP.tar.gz" -O - | tar zxvf - && \
    cd /opt/pjproject-$VERSION_PJSIP && \
    ./configure CFLAGS="-O2 -fPIC" \
                --prefix=/usr \
                && \
    make all install && \
    /sbin/ldconfig && \
    cd pjsip-apps/src/ && \
    git clone https://github.com/mgwilliams/python3-pjsip.git && \
    cd python3-pjsip && \
    python setup.py build && \
    python setup.py install && \
    rm -rf /opt/pjproject-$VERSION_PJSIP

RUN apt-get update && \
    apt-get install -yq apt-utils gconf-service libasound2 libatk1.0-0 libc6 libcairo2 \
    libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 \
    libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 \
    libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 mercurial rng-tools\
    libxrandr2 libxrender1 libxss1 libxtst6 libatk-bridge2.0-0 ca-certificates \
    fonts-liberation libnss3 lsb-release xdg-utils wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable xvfb fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf  \
      gtk2-engines-pixbuf xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable imagemagick x11-apps \
          --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /src/*.deb

# It's a good idea to use dumb-init to help prevent zombie chrome processes
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

ENV DISPLAY=:99