FROM fluent/fluentd:v1.11

USER root

RUN apk --update add tzdata \
    rm -rf /var/cache/apk/*

USER fluent
