# phpMyAdmin for Railway: official image, pinned by version and digest.
FROM phpmyadmin:5.2.3-apache@sha256:e4b3eb5305cd42d21512bb55def2bab52625d56df927ad4ee1864a9354c84d40

# Sensible defaults for a hosted instance (override with service variables).
ENV UPLOAD_LIMIT=512M \
    MEMORY_LIMIT=512M \
    MAX_EXECUTION_TIME=600 \
    HIDE_PHP_VERSION=1

COPY conf.d/ /etc/phpmyadmin/conf.d/
COPY railway-start.sh /usr/local/bin/railway-start.sh
RUN chmod 0755 /usr/local/bin/railway-start.sh \
 && chown -R www-data:www-data /etc/phpmyadmin/conf.d

ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
CMD ["apache2-foreground"]
