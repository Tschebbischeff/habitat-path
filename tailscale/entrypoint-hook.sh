#!/bin/sh

while :; do
  socat TCP-LISTEN:80,bind=127.0.0.1,reuseaddr,fork "TCP:${APP_NAME_HOST}_traefik:80"
  sleep 1
done &
while :; do
  socat TCP-LISTEN:443,bind=127.0.0.1,reuseaddr,fork "TCP:${APP_NAME_HOST}_traefik:443"
  sleep 1
done &
while :; do
  socat UDP-LISTEN:8189,bind=127.0.0.1,reuseaddr,fork "UDP:${APP_NAME_HOST}_traefik:8189"
  sleep 1
done &

[ -n "$TS_AUTHKEY_FILE" ] && export TS_AUTHKEY="$(cat "$TS_AUTHKEY_FILE")"

/usr/local/bin/containerboot