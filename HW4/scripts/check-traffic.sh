#!/usr/bin/env bash
set -u

while true; do
  for request_path in "/" "/api/counter"; do
    if http_code=$(
      curl \
        --noproxy '*' \
        --silent \
        --show-error \
        --fail \
        --connect-timeout 2 \
        --max-time 5 \
        --output /dev/null \
        --write-out '%{http_code}' \
        "https://counter.localtest.me${request_path}"
    ); then
      printf '%s path=%s HTTP=%s OK\n' \
        "$(date -Is)" "$request_path" "$http_code"
    else
      printf '%s path=%s HTTP=%s FAIL\n' \
        "$(date -Is)" "$request_path" "$http_code"
    fi
  done

  sleep 1
done
