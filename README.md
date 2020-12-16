### Install a 3 node hashicorp nomad cluster on Ubuntu 18
##### *Cluster has kompose, docker, private registry inlcuded in nmaster host*

[Install VirtualBox](https://www.virtualbox.org/wiki/Downloads)

[Install Vagrant](https://learn.hashicorp.com/tutorials/vagrant/getting-started-install)

***Clone repo***

```
cd ubuntu-nomad-cluster
```

#### Modify Vagrantfile according to your needs
*Specifically the memory and cpu according to your pc capacities*

##### ALL VAGRANT COMMANDS NEED TO BE RUN FROM WHERE Vagrantfile 
##### IS LOCATED IN THE ubuntu-nomad-cluster DIRECTORY!

```
vagrant up
```

##### Wait for process to finish, may take <= 10mins ish

##### After process completes you can view status of machines and SSH into them with below commands


#### Shows 3 machines status
```
vagrant status
```

#### To SSH into a machine from where the Vagrantfile exists
```
vagrant ssh nmaster
vagrant ssh nworker1
vagrant ssh nworker2
```

#### After you ssh into nmaster you can interact with your nomad cluster
```
nomad server members
nomad node status
```
#### You should see the following output respectively
```
Name                 Address        Port  Status  Leader  Protocol  Build  Datacenter  Region
nomad-master.global  172.42.42.100  4648  alive   true    2         1.0.0  dc1         global
```
```
ID        DC   Name          Class   Drain  Eligibility  Status
1468d293  dc1  nomad-agent2  <none>  false  eligible     ready
7a5a4b55  dc1  nomad-agent1  <none>  false  eligible     ready
```
#### I recommend taking a snapshot of your machines to restore to a good point if needed
```
vagrant snapshot save <snapShotName>
vagrant snapshot save fresh-nomad
```

#### Show your running docker registry in nmaster node
```
docker ps
```