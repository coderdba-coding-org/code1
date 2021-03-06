echo Starting `date`
echo Setting environment

export VERSION=0.0.1
export PACKER_LOG_PATH=/dev/stderr
export PACKER_LOG=1
export PACKER_CACHE_DIR=/data/packer_cache

echo Starting packer command

#-var 'artifactory_url=https://artifactory.art.com/artifactory' \
#-var 'builder_type=packer-openstack' \
#-var 'provisioner=provisionerless' \
#-var 'rpm=true' \

/data/bin/packer build -machine-readable \
centos7-g2-packer.json

echo Packer command completed

echo Moving new image to /data/images
/bin/mv centos7-base-img/centos7 /data/images/centos7-g2-${VERSION}.qcow2

echo Removing the temporary folder centos7-base-img
rmdir centos7-base-img

echo Ending `date`
