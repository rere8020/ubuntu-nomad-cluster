#!/bin/bash

VERSION="1.19.4"

echo "UPDATE HOSTS FILE"
cat >>/etc/hosts<<EOF
172.42.42.100 nomad-master.example.com nomad-master
172.42.42.101 nomad-agent1.example.com agent1
172.42.42.102 nomad-agent2.example.com agent2
EOF

echo "INSTALL DOCKER"
apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install docker-ce=5:19.03.14~3-0~ubuntu-bionic docker-ce-cli=5:19.03.14~3-0~ubuntu-bionic containerd.io -y

echo "INSTALLING JQ"
apt-get install jq -y

# add ccount to the docker group
usermod -aG docker vagrant

# add insecure registry
echo '{"insecure-registries":["nomad-master:5000"]}' > /etc/docker/daemon.json

# Enable docker service
echo "ENABLE AND START DOCKER"
systemctl enable docker >/dev/null 2>&1
systemctl start docker
systemctl restart docker

echo "ADD SYSCTL SETTINGS"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

echo "DISABLE SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

echo "INSTALLING TRANSPORT-HTTPS"
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

echo "ENABLE PASSWORD AUTH"
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

echo "SET ROOT PASSWORD"
echo -e "kubeadmin\nkubeadmin" | passwd root
#echo "kubeadmin" | passwd --stdin root >/dev/null 2>&1

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc

echo "INSTALLING NOMAD"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" 
apt-get update && sudo apt-get install nomad -y
echo "NOMAD VERSION"
nomad version

chmod 700 /etc/nomad.d

echo "CONFIGURE COMMON NOMAD CONFIG AND START NOMAD"
touch /etc/nomad.d/nomad.hcl
cat <<EOF > /etc/nomad.d/nomad.hcl
datacenter = "dc1"
data_dir = "/opt/nomad"
EOF

systemctl enable nomad.service
systemctl start nomad.service
