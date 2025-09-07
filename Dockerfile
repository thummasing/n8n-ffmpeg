FROM n8nio/n8n:latest

# --- Root stage ---
USER root

# ติดตั้ง ffmpeg + chromium + libs ที่ Puppeteer ต้องใช้
RUN apk update && apk add --no-cache \
  chromium ffmpeg nss harfbuzz freetype ttf-freefont ca-certificates

# ให้ puppeteer ใช้ chromium ในระบบ ไม่โหลดเอง
ENV PUPPETEER_SKIP_DOWNLOAD=1
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# อนุญาต Code node ให้ require external modules ได้
ENV NODE_FUNCTION_ALLOW_EXTERNAL=puppeteer,puppeteer-extra,puppeteer-extra-plugin-stealth

# ติดตั้ง global modules ด้วย root (จะไม่เจอ EACCES)
RUN npm i -g --unsafe-perm puppeteer puppeteer-extra puppeteer-extra-plugin-stealth \
 && chown -R node:node /usr/local/lib/node_modules /usr/local/bin

# ให้ Code node มองเห็น global modules
ENV NODE_PATH=/usr/local/lib/node_modules

# --- Community nodes ---
RUN mkdir -p /home/node/.n8n \
 && chown -R node:node /home/node/.n8n

USER node

# ใช้ชื่อ package.json ที่ถูกต้อง (ไม่ใช่ ".n8n")
RUN cd /home/node/.n8n \
 && printf '{ "name": "n8n-community", "version": "1.0.0" }\n' > package.json \
 && npm install n8n-nodes-ffmpeg n8n-nodes-puppeteer
