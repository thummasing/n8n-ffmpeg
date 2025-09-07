FROM n8nio/n8n:latest

# 1) ใช้สิทธิ์ root ก่อน
USER root

# 2) ลงระบบที่ต้องใช้
RUN apk update && apk add --no-cache \
  chromium ffmpeg nss harfbuzz freetype ttf-freefont ca-certificates

# 3) บอก puppeteer ให้ข้ามการดาวน์โหลด และชี้ chromium ในเครื่อง
ENV PUPPETEER_SKIP_DOWNLOAD=1
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# 4) อนุญาต Code node ให้ require โมดูลเหล่านี้
ENV NODE_FUNCTION_ALLOW_EXTERNAL=puppeteer,puppeteer-extra,puppeteer-extra-plugin-stealth

# 5) ติดตั้ง global ด้วยสิทธิ์ root (จะไม่เจอ EACCES)
RUN npm i -g --unsafe-perm puppeteer puppeteer-extra puppeteer-extra-plugin-stealth \
 && chown -R node:node /usr/local/lib/node_modules /usr/local/bin

# 6) ให้ Code node มองเห็น global modules เสมอ
ENV NODE_PATH=/usr/local/lib/node_modules

# 7) (ถ้าใช้ community nodes ด้วย) ใส่ไว้ในโฟลเดอร์ ~/.n8n ของ user node
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n
USER node
RUN cd /home/node/.n8n \
 && npm init -y \
 && npm install n8n-nodes-ffmpeg n8n-nodes-puppeteer
