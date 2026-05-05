#!/usr/bin/env bash

set -euo pipefail

TARGET_FILE="$1"
TARGET_FILE_CONTENT="$(cat "$TARGET_FILE")"

# ### Init

SOURCE_FILE_APP_CATEGORY="$(mktemp)"
SOURCE_FILE_APP_SITE="$(mktemp)"
SOURCE_FILE_DEV_REPOSITORIES="$(mktemp)"

APP_PAGE_NAME="Apps"
APP_PAGE_CATEGORY_NAME="Data"
DEV_PAGE_NAME="Development"

cat >"$SOURCE_FILE_APP_CATEGORY" <<EOF
type: monitor
cache: 10s
title: "$APP_PAGE_CATEGORY_NAME"
sites: []
EOF

cat >"$SOURCE_FILE_APP_SITE" <<'EOF'
- title: "Traefik Dashboard"
  url: https://traefik-dashboard.${APP_HOST}
  check-url: http://${APP_NAME_HOST}_traefik:8080
  icon: /assets/icons/di/traefik-proxy.svg
EOF

cat >"$SOURCE_FILE_DEV_REPOSITORIES" <<'EOF'
- dockerhub:traefik:latest
- dockerhub:tailscale/tailscale:stable
EOF

# ### Add to "Apps" page

# shellcheck disable=2016 # Variables are internal to yq expression
TARGET_FILE_CONTENT="$(yq eval '
  (
    .pages[] | select(.name == "'"$APP_PAGE_NAME"'") |
    .columns[0].widgets[] | select(.type == "split-column") |
    .widgets
  ) as $container | (
    $container[] | select(.title == "'"$APP_PAGE_CATEGORY_NAME"'")
  ) //= load("'"$SOURCE_FILE_APP_CATEGORY"'") |
  select(.title == "'"$APP_PAGE_CATEGORY_NAME"'").sites += load("'"$SOURCE_FILE_APP_SITE"'")
' <<<"$TARGET_FILE_CONTENT")"

# ### Add to "Development" page

# shellcheck disable=2016 # Variables are internal to yq expression
TARGET_FILE_CONTENT="$(yq eval '
  ( .pages[] | select(.name == "'"$DEV_PAGE_NAME"'").columns[0].widgets | select (.type == "releases") )
  .repositories += load("'"$SOURCE_FILE_DEV_REPOSITORIES"'")
' <<<"$TARGET_FILE_CONTENT")"

# ### Clean Up, Print Result and Exit
rm "$SOURCE_FILE_APP_CATEGORY" "$SOURCE_FILE_APP_SITE" "$SOURCE_FILE_DEV_REPOSITORIES"

echo "$TARGET_FILE_CONTENT"
exit 0