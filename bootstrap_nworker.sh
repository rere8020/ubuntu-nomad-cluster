#!/bin/bash

echo "CONFIGURE NOMAD CLIENT"
touch /etc/nomad.d/client.hcl

cat <<EOF > /etc/nomad.d/client.hcl
client {
  enabled = true
  servers = ["172.42.42.100"]
}
EOF

echo "START NOMAD"
systemctl enable nomad
systemctl start nomad
systemctl restart nomad

