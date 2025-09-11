FROM n8nio/n8n:latest

# --- Root ---
USER root

# 1) deps พื้นฐานที่ Puppeteer / Playwright ใช้บ่อย
RUN apk update && apk add --no-cache \
  bash \
  ffmpeg \
  nss \
  harfbuzz \
  freetype \
  ttf-freefont \
  ca-certificates

# 2) อนุญาต Code node ให้ require modules เหล่านี้ได้
ENV NODE_FUNCTION_ALLOW_EXTERNAL=puppeteer,puppeteer-extra,puppeteer-extra-plugin-stealth,playwright,@playwright/test
# ให้เห็น global node_modules
ENV NODE_PATH=/usr/local/lib/node_modules

# 3) ติดตั้ง libs แบบ global + ให้ Playwright โหลด Chromium ตอน build
RUN npm i -g --unsafe-perm \
    puppeteer \
    puppeteer-extra \
    puppeteer-extra-plugin-stealth \
    playwright @playwright/test \
 && npx playwright install --with-deps chromium \
 && chown -R node:node /usr/local/lib/node_modules /usr/local/bin

# 4) เปิดใช้ community packages
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true
RUN mkdir -p /home/node/.n8n/nodes && chown -R node:node /home/node/.n8n

# --- Switch to node user ---
USER node
WORKDIR /home/node/.n8n

# 5) สร้าง package.json ที่ชื่อถูกต้อง + ติดตั้ง community nodes
RUN printf '{ "name": "n8n-community", "version": "1.0.0" }\n' > package.json \
 && npm install n8n-nodes-ffmpeg n8n-nodes-puppeteer
