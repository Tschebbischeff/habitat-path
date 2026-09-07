#!/bin/sh

MAIN_PID=$$

cat "$TS_SERVE_CONFIG" | grep -Po '127\.0\.0\.1:\K[0-9]*' | while read -r port; do (
  while kill -0 "$MAIN_PID" 2>/dev/null; do
    socat "TCP-LISTEN:$port,bind=127.0.0.1,reuseaddr,fork" "TCP:${APP_NAME_HOST}_traefik:$port"
    sleep 1
  done
) & done

[ -n "$TS_AUTHKEY_FILE" ] && export TS_AUTHKEY="$(cat "$TS_AUTHKEY_FILE")"

exec "$@"