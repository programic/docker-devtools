FROM alpine:latest

RUN apk add --no-cache bash openssl \
    && mkdir /output

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

WORKDIR /output

CMD ["/entrypoint.sh"]