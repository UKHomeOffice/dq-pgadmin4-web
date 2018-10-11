FROM python:2-alpine3.7
LABEL maintainer="James.Rowley1@homeoffice.gsi.gov.uk"

ENV USERMAP_UID 1000
ENV USERMAP_GID 50
ENV PGADMIN_VERSION=3.0 \
    PYTHONDONTWRITEBYTECODE=1

# Install postgresql tools for backup/restore
RUN apk add --no-cache postgresql \
 && cp /usr/bin/psql /usr/bin/pg_dump /usr/bin/pg_dumpall /usr/bin/pg_restore /usr/local/bin/ \
 && apk del postgresql

RUN apk add --no-cache alpine-sdk postgresql-dev \
 && pip install --upgrade pip \
 && echo "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py2.py3-none-any.whl" | pip install --no-cache-dir -r /dev/stdin \
 && addgroup -g ${USERMAP_GID} -S ${USERMAP_GID} \
 && adduser -D -S -h /pgadmin -s /sbin/nologin -u ${USERMAP_UID} -G ${USERMAP_GID} ${USERMAP_UID} \
 && mkdir -p /pgadmin/config /pgadmin/storage \
 && chown -R ${USERMAP_UID}:${USERMAP_GID} /pgadmin

EXPOSE 5050

COPY config_distro.py /usr/local/lib/python2.7/site-packages/pgadmin4/

USER ${USERMAP_UID}
CMD ["python", "./usr/local/lib/python2.7/site-packages/pgadmin4/pgAdmin4.py"]
VOLUME /pgadmin/
