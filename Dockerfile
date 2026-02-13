FROM searxng/searxng:latest

# Bake the config
COPY settings.yml /etc/searxng/settings.yml

# Run as root + fix permissions (eliminates all cert warnings)
USER root
RUN update-ca-certificates --fresh && \
    chown -R searxng:searxng /etc/searxng && \
    chmod -R 755 /etc/searxng

USER searxng