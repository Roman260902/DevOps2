FROM alpine:3.18 AS supercronic-download

ARG SUPERCRONIC_VERSION=v0.2.51
ARG SUPERCRONIC_SHA1SUM=1692066e350a88ff4d7d6474fe3c7a6c41ec5e89

RUN apk add --no-cache curl \
    && curl -fsSL \
        "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-amd64" \
        -o /usr/local/bin/supercronic \
    && echo "${SUPERCRONIC_SHA1SUM}  /usr/local/bin/supercronic" \
        | sha1sum -c - \
    && chmod +x /usr/local/bin/supercronic


FROM python:3.11.6-alpine3.18

SHELL ["/bin/sh", "-eu", "-c"]

ARG APP_USER=appuser
ARG APP_UID=1001
ARG APP_GID=1001
ARG APP_HOME=/app

RUN addgroup -S -g "${APP_GID}" "${APP_USER}" \
    && adduser -S -D -H \
        -u "${APP_UID}" \
        -G "${APP_USER}" \
        "${APP_USER}" \
    && mkdir -p "${APP_HOME}" /config \
    && chown -R "${APP_USER}:${APP_USER}" "${APP_HOME}" /config

COPY --from=supercronic-download \
    /usr/local/bin/supercronic \
    /usr/local/bin/supercronic

WORKDIR ${APP_HOME}

COPY --chown=${APP_UID}:${APP_GID} probe.py ./probe.py
COPY --chown=${APP_UID}:${APP_GID} crontab ./crontab

RUN supercronic -test /app/crontab

USER ${APP_USER}

CMD ["supercronic", "-split-logs", "/app/crontab"]
