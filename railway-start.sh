#!/bin/bash
# Railway wrapper for the official phpMyAdmin image.
set -e

# Railway's runtime can bring back the mpm_event/mpm_worker links that the base
# image removed, and Apache then refuses to start ("AH00534: More than one MPM
# loaded"). PHP's mod_php needs prefork, so keep only that one.
for mpm in event worker; do
  rm -f "/etc/apache2/mods-enabled/mpm_${mpm}.load" "/etc/apache2/mods-enabled/mpm_${mpm}.conf"
done
if [ ! -e /etc/apache2/mods-enabled/mpm_prefork.load ]; then
  ln -s ../mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
  ln -sf ../mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf
fi

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
