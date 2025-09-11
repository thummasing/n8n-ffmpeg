FROM n8nio/n8n:latest

# --- Root ---
USER root

# 1) System deps (เพิ่ม chromium ให้ puppeteer/playwright ใช้)
RUN apk update && apk add --no-cache \
  chromium ffmpeg nss harfbuzz freetype ttf-freefont ca-certificates

# 2) Puppeteer ใช้ system Chromium
ENV PUPPETEER_SKIP_DOWNLOAD=1
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# 3) Playwright ใช้ system Chromium (ไม่โหลด browser เอง)
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

# 4) อนุญาต Code node ให้ require ได้
ENV NODE_FUNCTION_ALLOW_EXTERNAL=puppeteer,puppeteer-extra,puppeteer-extra-plugin-stealth,playwright,@playwright/test

# 5) ติดตั้ง global modules (puppeteer + playwright)
RUN npm i -g --unsafe-perm \
    puppeteer \
    puppeteer-extra \
    puppeteer-extra-plugin-stealth \
    playwright @playwright/test \
 && chown -R node:node /usr/local/lib/node_modules /usr/local/bin

# 6) ให้ Code node มองเห็น global modules
ENV NODE_PATH=/usr/local/lib/node_modules

# --- Community nodes ---
RUN mkdir -p /home/node/.n8n/nodes && chown -R node:node /home/node/.n8n

# เปิดใช้ community packages
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true

# --- Switch to node ---
USER node
WORKDIR /home/node/.n8n

# Valid package.json + ติดตั้ง community nodes
RUN printf '{ "name": "n8n-community", "version": "1.0.0" }\n' > package.json \
 && npm install n8n-nodes-ffmpeg n8n-nodes-puppeteer
