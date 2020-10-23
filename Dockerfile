FROM mongo:4.4.1
RUN apt-get update
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates curl openssh-client && rm -rf /var/lib/apt/lists/* \
	&& curl -L https://github.com/prodrigestivill/go-cron/releases/download/v0.0.9/go-cron-linux-amd64.gz | zcat > /usr/local/bin/go-cron \
	&& chmod a+x /usr/local/bin/go-cron \
	&& apt-get purge -y --auto-remove ca-certificates && apt-get clean

ENV BACKUP_DIR_PATH=/backup \
    BACKUP_SUFFIX=.dump \
    SSH_USER=root \
    HEALTHCHECK_PORT=8080 \
    SCHEDULE="@daily"

COPY ./backup.sh /
RUN chmod +x ./backup.sh

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["exec /usr/local/bin/go-cron -s \"$SCHEDULE\" -p \"$HEALTHCHECK_PORT\" -- /backup.sh"]

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f "http://localhost:$HEALTHCHECK_PORT/" || exit 1
