#!/usr/bin/env bash

cd "/habitat-config" || exit 1

for dirPath in "./source/"*; do
    echo "Applying configuration for '$APP_MODULE_NAME' ($(basename "$dirPath"))"
    # Traefik Dynamic Config
    echo "Applying traefik config"
    if [ -d "./source/$dirPath/traefik" ]; then
        rm -f "./target/traefik/${APP_MODULE_NAME}."*
        for f in "./source/$dirPath/traefik/"*; do
            cp "$f" "./target/traefik/${APP_MODULE_NAME}.$(basename "$f")";
        done
    fi
done