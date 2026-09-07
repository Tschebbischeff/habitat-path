FROM tailscale/tailscale:stable

COPY ./entrypoint-hook.sh /entrypoint-hook.sh
RUN chmod +x /entrypoint-hook.sh

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.21/main/ socat grep

ENTRYPOINT ["/entrypoint-hook.sh"]
CMD ["/usr/local/bin/containerboot"]