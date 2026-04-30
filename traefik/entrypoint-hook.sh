#!/bin/sh

[ -f /run/secrets/PORKBUN_API_KEY ] && export PORKBUN_API_KEY="$(cat /run/secrets/PORKBUN_API_KEY 2>/dev/null)"
[ -f /run/secrets/PORKBUN_API_SECRET_KEY ] && export PORKBUN_SECRET_API_KEY="$(cat /run/secrets/PORKBUN_API_SECRET_KEY 2>/dev/null)"

exec "$@"