ARG TRAEFIK_VERSION
FROM traefik:${TRAEFIK_VERSION:?}

COPY ./entrypoint-hook.sh /entrypoint-hook.sh
RUN chmod +x /entrypoint-hook.sh

ENTRYPOINT ["/entrypoint-hook.sh"]
CMD ["traefik", "--configfile=/etc/traefik/traefik.yml"]