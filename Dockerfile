FROM searxng/searxng:latest

COPY settings.yml /etc/searxng/settings.yml

USER root

# Update certificates at build time & fix permissions
RUN update-ca-certificates && \
    chown -R searxng:searxng /etc/searxng && \
    chmod -R 755 /etc/searxng && \
    # Ensure the certs directory is writable if runtime updates are needed (optional but safer)
    chown -R searxng:searxng /etc/ssl/certs

USER searxng