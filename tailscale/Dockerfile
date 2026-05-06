FROM tailscale/tailscale:stable

COPY ./entrypoint-hook.sh /entrypoint-hook.sh
RUN chmod +x /entrypoint-hook.sh

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.21/main/ socat=1.8.0.3-r0 grep

CMD ["sh", "-c", "/entrypoint-hook.sh"]