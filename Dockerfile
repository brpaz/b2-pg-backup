FROM alpine:3.15

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION
ARG B2_CLI_VERSION="v3.2.0"


RUN apk add --no-cache curl gzip postgresql14-client && \
    curl -LO https://github.com/Backblaze/B2_Command_Line_Tool/releases/download/${B2_CLI_VERSION}/b2-linux && \
    chmod +x b2-linux && \
    mv b2-linux /usr/local/bin/b2 && \
    b2 version

COPY backup.sh /usr/local/bin/backup.sh
CMD ["/usr/local/bin/backup.sh"]

# Labels.
LABEL maintainer="Bruno Paz"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="brpaz/backblaze-pg-backup"
LABEL org.label-schema.description="Backup a Postgres database to Backbalze using pg_dump"
LABEL org.label-schema.url="https://github.com/brpaz/backblaze-pg-backup"
LABEL org.label-schema.vcs-url="https://github.com/brpaz/backblaze-pg-backup"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.version=$BUILD_VERSION