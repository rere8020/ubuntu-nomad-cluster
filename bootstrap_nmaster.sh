#!/bin/bash
KOMPOSE_VERSION="v1.22.0"

echo "START DOCKER REGISTRY"
docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name my_registry \
  -v /mnt/registry:/var/lib/registry \
  registry:2

echo "INSTALL KOMPOSE"
curl -L https://github.com/kubernetes/kompose/releases/download/$KOMPOSE_VERSION/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo mv ./kompose /usr/local/bin/kompose

echo "CONFIGURE NOMAD SERVER"
touch /etc/nomad.d/server.hcl

cat <<EOF > /etc/nomad.d/server.hcl
server {
  enabled = true
  bootstrap_expect = 1
}
advertise {
  http = "172.42.42.100:4646"
  rpc  = "172.42.42.100:4647"
  serf = "172.42.42.100:4648"
}
EOF

echo "START NOMAD"
systemctl enable nomad
systemctl start nomad
systemctl restart nomad
