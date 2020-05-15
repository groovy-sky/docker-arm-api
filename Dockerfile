FROM alpine:latest
RUN apk add --no-cache curl jq
COPY start.sh /
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
