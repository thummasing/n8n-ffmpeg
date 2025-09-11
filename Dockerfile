FROM n8nio/n8n:latest

USER root

# base libs
RUN apk add --no-cache \
    bash \
    ffmpeg \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    wget \
    curl \
    unzip \
    xvfb \
    chromium \
    chromium-chromedriver \
    udev \
    mesa-utils \
    mesa-dri-gallium \
    libstdc++ \
    libc6-compat \
    alsa-lib \
    at-spi2-core \
    pango \
    gtk+3.0 \
    dbus

ENV NODE_FUNCTION_ALLOW_EXTERNAL=puppeteer,puppeteer-extra,puppeteer-extra-plugin-stealth,playwright,@playwright/test
ENV NODE_PATH=/usr/local/lib/node_modules

RUN npm i -g --unsafe-perm \
    puppeteer \
    puppeteer-extra \
    puppeteer-extra-plugin-stealth \
    playwright @playwright/test \
 && npx playwright install chromium \
 && chown -R node:node /usr/local/lib/node_modules /usr/local/bin

ENV N8N_COMMUNITY_PACKAGES_ENABLED=true
RUN mkdir -p /home/node/.n8n/nodes && chown -R node:node /home/node/.n8n

USER node
WORKDIR /home/node/.n8n

RUN printf '{ "name": "n8n-community", "version": "1.0.0" }\n' > package.json \
 && npm install n8n-nodes-ffmpeg n8n-nodes-puppeteer
