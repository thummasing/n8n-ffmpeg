FROM n8nio/n8n:latest

USER root
# ติดตั้ง FFmpeg + Chromium + lib ที่จำเป็น
RUN apk update && apk add --no-cache \
  ffmpeg \
  chromium \
  nss \
  harfbuzz \
  freetype \
  ttf-freefont \
  ca-certificates

# ชี้ให้ Puppeteer ข้ามการดาวน์โหลด และใช้ Chromium ที่ติดตั้งในระบบ
ENV PUPPETEER_SKIP_DOWNLOAD=1
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# อนุญาต Code node ให้ require โมดูล external
ENV NODE_FUNCTION_ALLOW_EXTERNAL=puppeteer

USER node
# ติดตั้ง puppeteer เป็น global
RUN npm install -g puppeteer

# (ถ้า Code node หา global module ไม่เจอ ให้เปิดใช้บรรทัดนี้)
# ENV NODE_PATH=/usr/local/lib/node_modules
