#!/usr/bin/env bash

cd "/habitat-config" || exit 1

for dirPath in "./source/"*; do
    echo "*** Applying configuration for '$APP_MODULE_NAME' (Source directory: $(basename "$dirPath"))"
    # Traefik Dynamic Config
    if [ -d "./target/traefik" ]; then
        echo "Applying traefik config"
        if [ -d "./source/$dirPath/traefik" ]; then
            rm -f "./target/traefik/${APP_MODULE_NAME}."*
            for f in "./source/$dirPath/traefik/"*; do
                cp "$f" "./target/traefik/${APP_MODULE_NAME}.$(basename "$f")";
            done
        fi
    fi
done