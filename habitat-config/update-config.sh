#!/usr/bin/env bash

cd "/habitat-config" || exit 1

for dirPath in "./source/"*; do
    echo "*** Applying configuration for module '$APP_MODULE_NAME' (Source directory: /habitat-config/source/$(basename "$dirPath"))..."
    # Traefik Dynamic Config
    if [ -d "./target/traefik" ]; then
        echo "Traefik config:"
        rm -f "./target/traefik/${APP_MODULE_NAME}."*
        if [ -d "$dirPath/traefik" ]; then
            for f in "$dirPath/traefik/"*; do
                echo " $f -> ./target/traefik/${APP_MODULE_NAME}.$(basename "$f")"
                cp "$f" "./target/traefik/${APP_MODULE_NAME}.$(basename "$f")";
            done
        else
            echo " None"
        fi
    fi
done