FROM alpine:latest
ENV DIRPATH /opt

RUN apk add --no-cache curl jq
WORKDIR $DIRPATH
COPY ./start.sh $DIRPATH/start.sh
RUN chmod +x $DIRPATH/start.sh
CMD ["$DIRPATH/start.sh"]
