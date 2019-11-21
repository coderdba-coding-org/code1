FROM busybox

ADD sleep.sh /tmp
WORKDIR /tmp
CMD chmod +x /tmp/sleep.sh

ENTRYPOINT [ "./sleep.sh" ]
