docker pull prom/node-exporter

docker run -d -p 9100:9100 --user 995:995 \
-v "/:/hostfs" \
--net="host" \
prom/node-exporter \
--path.rootfs=/hostfs
