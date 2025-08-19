FROM jlesage/makemkv:latest

# Install Python and Apprise for multi-channel notifications
RUN apk add --no-cache \
    python3 \
    py3-pip \
    curl && \
    pip3 install --break-system-packages --no-cache-dir apprise

# Copy our enhanced scripts
COPY startapp.sh /startapp.sh
COPY makemkv-monitor.sh /usr/local/bin/makemkv-monitor.sh
COPY log-watcher.sh /usr/local/bin/log-watcher.sh
COPY notify.py /usr/local/bin/notify.py

# Make scripts executable
RUN chmod +x /startapp.sh /usr/local/bin/makemkv-monitor.sh /usr/local/bin/log-watcher.sh /usr/local/bin/notify.py

# Add environment variable documentation
ENV NOTIFY_START="1"

# Labels for documentation
LABEL maintainer="stonefish"
LABEL description="MakeMKV with Docker logging and Apprise notifications"
LABEL org.opencontainers.image.source="https://github.com/st0nefish/docker-makemkv"

# The rest is inherited from the base image