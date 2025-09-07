FROM n8nio/n8n:latest

USER root
# libs + chromium
RUN apk update && apk add --no-cache \
  chromium ffmpeg nss harfbuzz freetype ttf-freefont ca-certificates

# ให้ puppeteer ข้ามการโหลด browser และชี้ไป chromium ในระบบ
ENV PUPPETEER_SKIP_DOWNLOAD=1
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
# อนุญาต Code node require โมดูลพวกนี้
ENV NODE_FUNCTION_ALLOW_EXTERNAL=puppeteer,puppeteer-extra,puppeteer-extra-plugin-stealth

# ติดตั้ง global ด้วยสิทธิ์ root (จะไม่เจอ EACCES)
RUN npm i -g --unsafe-perm puppeteer puppeteer-extra puppeteer-extra-plugin-stealth \
 && chown -R node:node /usr/local/lib/node_modules /usr/local/bin

# (ให้ Code node มองเห็น global modules เสมอ)
ENV NODE_PATH=/usr/local/lib/node_modules

USER node
