FROM searxng/searxng:latest

# Bake the full settings (Render free tier has no persistent storage)
COPY settings.yml /etc/searxng/settings.yml

# Fix permissions
USER root
RUN chown searxng:searxng /etc/searxng/settings.yml && \
    chmod 644 /etc/searxng/settings.yml
USER searxng