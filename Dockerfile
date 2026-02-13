FROM searxng/searxng:latest

# Bake settings
COPY settings.yml /etc/searxng/settings.yml

# Fix permissions + pre-update certificates (as root)
USER root
RUN update-ca-certificates --fresh && \
    chown searxng:searxng /etc/searxng/settings.yml && \
    chmod 644 /etc/searxng/settings.yml
USER searxng