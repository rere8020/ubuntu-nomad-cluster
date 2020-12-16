# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "bootstrap.sh"

  # Kubernetes Master Server
  config.vm.define "nmaster" do |nmaster|
    nmaster.vm.box = "bento/ubuntu-18.04"
    nmaster.vm.hostname = "nomad-master.example.com"
    nmaster.vm.network "private_network", ip: "172.42.42.100"
    #nmaster.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true
    nmaster.vm.provider "virtualbox" do |v|
      v.name = "nomad-master"
      v.memory = 3072
      v.cpus = 2
    end
    nmaster.vm.provision "shell", path: "bootstrap_nmaster.sh"
  end

  NodeCount = 2

  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "nworker#{i}" do |nworker|
      nworker.vm.box = "bento/ubuntu-18.04"
      nworker.vm.hostname = "nomad-agent#{i}.example.com"
      nworker.vm.network "private_network", ip: "172.42.42.10#{i}"
      nworker.vm.provider "virtualbox" do |v|
        v.name = "agent#{i}"
        v.memory = 3072
        v.cpus = 2
      end
      nworker.vm.provision "shell", path: "bootstrap_nworker.sh"
    end
  end

end
