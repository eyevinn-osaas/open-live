#!/bin/bash
set -e

# === OSC Public URL Configuration ===
if [ -n "$OSC_HOSTNAME" ]; then
  export PUBLIC_URL="https://$OSC_HOSTNAME"
  # Map to CORS_ORIGIN so the studio frontend can reach this instance
  export CORS_ORIGIN="${CORS_ORIGIN:-https://$OSC_HOSTNAME}"
fi

# === Default PORT for OSC ===
export PORT="${PORT:-8080}"

# === Execute the original command ===
exec "$@"
