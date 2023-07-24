FROM node:16.20.1-bookworm-slim as builder
WORKDIR /tmp
RUN apt-get update \
    && apt-get install -y python build-essential pkg-config libcairo2-dev \
    && rm -rf /var/lib/apt/lists/*
COPY ./nanohat-oled-nodejs/package.json /tmp/package.json
COPY ./nanohat-oled-nodejs/package-lock.json /tmp/package-lock.json
RUN npm config set unsafe-perm true \
    && npm update -y -g npm \
    && npm install \
    && npm config set unsafe-perm false

FROM node:16.20.1-bookworm-slim
ENV TZ 'Asia/Tokyo'
ARG ARCH='aarch64'
ARG LOGO_URL="https://github.com/friendlyarm/BakeBit/raw/master/Software/Python/friendllyelec.png"
WORKDIR /tmp

COPY ./nanohat-oled-nodejs/gpioemitter.js /tmp/gpioemitter.js
COPY ./nanohat-oled-nodejs/index.js /tmp/index.js
COPY ./nanohat-oled-nodejs/mplus_f10r.bdf /tmp/mplus_f10r.bdf
COPY ./nanohat-oled-nodejs/oled.js /tmp/oled.js
COPY ./nanohat-oled-nodejs/package.json /tmp/package.json
COPY ./nanohat-oled-nodejs/package-lock.json /tmp/package-lock.json

COPY --from=builder /tmp/node_modules /tmp/node_modules
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libpixman-1.so.0 /usr/lib/${ARCH}-linux-gnu/libpixman-1.so.0
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libcairo.so.2 /usr/lib/${ARCH}-linux-gnu/libcairo.so.2
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libpng16.so.16 /usr/lib/${ARCH}-linux-gnu/libpng16.so.16
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libfontconfig.so.1 /usr/lib/${ARCH}-linux-gnu/libfontconfig.so.1
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libfreetype.so.6 /usr/lib/${ARCH}-linux-gnu/libfreetype.so.6
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libxcb-shm.so.0 /usr/lib/${ARCH}-linux-gnu/libxcb-shm.so.0
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libxcb.so.1 /usr/lib/${ARCH}-linux-gnu/libxcb.so.1
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libxcb-render.so.0 /usr/lib/${ARCH}-linux-gnu/libxcb-render.so.0
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libXrender.so.1 /usr/lib/${ARCH}-linux-gnu/libXrender.so.1
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libX11.so.6 /usr/lib/${ARCH}-linux-gnu/libX11.so.6
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libXext.so.6 /usr/lib/${ARCH}-linux-gnu/libXext.so.6
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libXau.so.6 /usr/lib/${ARCH}-linux-gnu/libXau.so.6
COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libXdmcp.so.6 /usr/lib/${ARCH}-linux-gnu/libXdmcp.so.6
COPY --from=builder /lib/${ARCH}-linux-gnu/libexpat.so.1 /lib/${ARCH}-linux-gnu/libexpat.so.1
COPY --from=builder /lib/${ARCH}-linux-gnu/libbsd.so.0 /lib/${ARCH}-linux-gnu/libbsd.so.0

ADD ${LOGO_URL} /tmp/logo_img
ENTRYPOINT ["node"]
CMD ["/tmp/index.js"]