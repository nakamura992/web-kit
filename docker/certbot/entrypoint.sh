#!/bin/sh

if [ "${USE_SSL:-false}" = "true" ]; then
    certbot certonly --webroot -w /var/www/certbot --force-renewal --email "${LETSENCRYPT_EMAIL}" -d "${DOMAIN}" --agree-tos

    trap exit TERM
    while :; do
        certbot renew
        sleep 12h & wait $!
    done
else
    echo "SSL is not enabled. Skipping certbot."
    sleep infinity
fi
