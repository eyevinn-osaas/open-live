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
  # config.ts only reads PUBLIC_BASE_URL — PUBLIC_URL is not a variable the
  # app looks at. Without this, PUBLIC_BASE_URL stays unset on OSC and the
  # production guard added in Eyevinn/open-live#147 refuses to start.
  export PUBLIC_BASE_URL="${PUBLIC_BASE_URL:-https://$OSC_HOSTNAME}"
  # Map to CORS_ORIGIN so the studio frontend can reach this instance
  export CORS_ORIGIN="${CORS_ORIGIN:-https://$OSC_HOSTNAME}"
fi

# === Default PORT for OSC ===
export PORT="${PORT:-8080}"

# === External auth acknowledgement ===
# The published OSC service schema has no API_KEY config option, so API_KEY is
# never set on OSC-hosted instances. OSC's own reverse proxy is the external
# auth layer in front of every instance, so acknowledge that by default here
# rather than relying on NODE_ENV (which is always "production" on OSC and
# says nothing about auth architecture). See Eyevinn/open-live#234.
export TRUST_EXTERNAL_AUTH="${TRUST_EXTERNAL_AUTH:-true}"

# === Execute the original command ===
exec "$@"
