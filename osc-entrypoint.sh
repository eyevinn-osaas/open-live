#!/bin/bash
set -e

# === DATABASE_URL parsing ===
# DATABASE_URL format: http(s)://host:port/dbname
if [ -n "$DATABASE_URL" ]; then
  # Strip the database name (last path segment) to get COUCHDB_URL
  export COUCHDB_URL="${DATABASE_URL%/*}"
  # Extract the database name
  export COUCHDB_NAME="${DATABASE_URL##*/}"
fi

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
