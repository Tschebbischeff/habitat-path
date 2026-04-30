#!/usr/bin/env bash

cd "/habitat-config" || exit 1

# Traefik Dynamic Config
if [ -d "./source/traefik" ]; then
    rm -f "./target/traefik/${APP_MODULE_NAME}."*
    for f in "./source/traefik/"*; do
        cp "$f" "./target/traefik/${APP_MODULE_NAME}.$(basename "$f")";
    done
fi