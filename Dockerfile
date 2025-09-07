FROM n8nio/n8n:latest

# --- Root ---
USER root

# 1) System deps
RUN apk update && apk add --no-cache \
  chromium ffmpeg nss harfbuzz freetype ttf-freefont ca-certificates

# 2) Puppeteer uses system Chromium
ENV PUPPETEER_SKIP_DOWNLOAD=1
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# 3) Allow Code node to require these
ENV NODE_FUNCTION_ALLOW_EXTERNAL=puppeteer,puppeteer-extra,puppeteer-extra-plugin-stealth

# 4) Install puppeteer libs globally (no EACCES)
RUN npm i -g --unsafe-perm puppeteer puppeteer-extra puppeteer-extra-plugin-stealth \
 && chown -R node:node /usr/local/lib/node_modules /usr/local/bin

# Make sure Code node sees global modules
ENV NODE_PATH=/usr/local/lib/node_modules

# --- Community nodes (IMPORTANT: install under ~/.n8n/nodes) ---
RUN mkdir -p /home/node/.n8n/nodes && chown -R node:node /home/node/.n8n

# Enable community packages UI/loader (safety)
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true

USER node
WORKDIR /home/node/.n8n/nodes

# Valid package.json (can't be ".n8n")
RUN printf '{ "name": "n8n-community", "version": "1.0.0" }\n' > package.json \
 && npm install n8n-nodes-ffmpeg n8n-nodes-puppeteer
