FROM n8nio/n8n:latest


USER root

# Add all your packages here
RUN apk update && \
    apk add --no-cache ffmpeg

USER node