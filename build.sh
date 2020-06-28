sudo podman container exists boot2podman-open-iscsi-build \
	|| sudo podman run -d --name=boot2podman-open-iscsi-build -v ./patch:/patch localhost/tinycore-go:1.12.10 sh -c 'while true; do sleep 3600; done'
$(sudo podman inspect --format '{{.State.Running}}' boot2podman-open-iscsi-build) \
	|| sudo podman start boot2podman-open-iscsi-build

sudo podman exec -i boot2podman-open-iscsi-build sh -xe < compile-dep
sudo podman exec -i boot2podman-open-iscsi-build sh -xe < compile
sudo podman exec -i boot2podman-open-iscsi-build sh -xe < package

mnt=$(sudo podman mount boot2podman-open-iscsi-build)
sudo sh -c "cp -p ${mnt}/home/tc/*.tcz* ."
sudo podman umount boot2podman-open-iscsi-build
