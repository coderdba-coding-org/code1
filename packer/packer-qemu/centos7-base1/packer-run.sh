echo Starting `date`
echo Setting environment

export VERSION=0.0.1
export PACKER_LOG_PATH=/dev/stderr 
export PACKER_LOG=1 
export PACKER_CACHE_DIR=/data/packer_cache 

echo Starting packer command

#-var 'artifactory_url=https://artifactory.company.com/artifactory' \
#-var 'builder_type=packer-openstack' \

/data/bin/packer build \
-var 'provisioner=provisionerless' \
-var 'rpm=true' \
centos7-base-packer.json

echo Packer command completed

echo Moving new image to /data/images
mv centos7-base-img/centos7-base-gp /data/images/centos7-base-gp-${VERSION}.qcow2

echo Removing the temporary folder centos7-base-img
rmdir centos7-base-img

echo Ending `date`
