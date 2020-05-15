FROM alpine:latest
RUN apk add --no-cache curl jq
WORKDIR /opt
COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]
