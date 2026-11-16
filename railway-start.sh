#!/bin/bash
# Railway wrapper for the official phpMyAdmin image.
set -e

# Apache listens on Railway's PORT (the official entrypoint rewrites ports.conf).
export APACHE_PORT="${PORT:-80}"

# Behind Railway's HTTPS proxy, tell phpMyAdmin its public URL.
if [ -z "${PMA_ABSOLUTE_URI:-}" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
  export PMA_ABSOLUTE_URI="https://${RAILWAY_PUBLIC_DOMAIN}/"
fi

# Stable cookie-encryption secret from a variable, so every replica and redeploy
# uses the same one. Without it the image generates a random one per container.
if [ -n "${PMA_BLOWFISH_SECRET:-}" ]; then
  php -r 'file_put_contents("/etc/phpmyadmin/config.secret.inc.php", "<?php\n\$cfg[\"blowfish_secret\"] = " . var_export(getenv("PMA_BLOWFISH_SECRET"), true) . ";\n");'
fi

exec /docker-entrypoint.sh "$@"
