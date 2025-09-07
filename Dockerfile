FROM n8nio/n8n:latest

USER root
# Chromium + ffmpeg (ไบนารีระบบ)
RUN apk update && apk add --no-cache \
  chromium ffmpeg nss harfbuzz freetype ttf-freefont ca-certificates

# Puppeteer ชี้ไปที่ chromium ในระบบ
ENV PUPPETEER_SKIP_DOWNLOAD=1
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# ให้ Code node อนุญาต external modules ที่เราจะใช้
ENV NODE_FUNCTION_ALLOW_EXTERNAL=puppeteer,puppeteer-extra,puppeteer-extra-plugin-stealth

# เตรียมโฟลเดอร์ community packages (ตรงนี้สำคัญมาก)
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

USER node
# ติดตั้ง libs ฝั่งโค้ด
RUN npm i -g puppeteer puppeteer-extra puppeteer-extra-plugin-stealth

# ติดตั้ง "Community nodes" ลง /home/node/.n8n เพื่อให้ n8n โหลดตอนสตาร์ต
RUN cd /home/node/.n8n \
 && npm init -y \
 && npm install n8n-nodes-ffmpeg n8n-nodes-puppeteer

# ทำให้ Code node มองเห็น global modules (กันพลาด)
ENV NODE_PATH=/usr/local/lib/node_modules
