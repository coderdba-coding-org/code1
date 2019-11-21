FROM alpine

RUN apk add --update dumb-init && mkdir /certs
ADD my-cert-agent /

ENTRYPOINT ["dumb-init", "/my-cert-agent"]
