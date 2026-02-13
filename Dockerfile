FROM searxng/searxng:latest

COPY settings.yml /etc/searxng/settings.yml

USER root
RUN update-ca-certificates --fresh && \
    chown -R searxng:searxng /etc/searxng && \
    chmod -R 755 /etc/searxng
USER searxng