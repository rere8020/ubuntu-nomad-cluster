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

#### To access the nomad GUI, edit your hosts file and add below entries
```
172.42.42.100 nomad-master.example.com
172.42.42.101 nomad-agent1.example.com
172.42.42.102 nomad-agent2.example.com
```
#### On your browser navigate to http://nomad-master.example.com:4646

### Sample job to try nomad

##### On nmaster host
```
nomad job init -short drain-example.nomad
# view the file
vim drain-example.nomad 
nomad job plan drain-example.nomad 
nomad job run drain-example.nomad 
nomad job status
# get the node ID we will use it for the demo
nomad job status example
```
#### With node ID from above
```
vagrant ssh <nworker[n]>
```
#### Once in the node where the job is running, run below commands
*Commands can be run from any node, this is just to see the docker container on the host that is running it*
```
# show the running container
docker ps
nomad node eligibility -disable 8593ceb2 # this is the node ID
# container still running there but node will not receive new jobs
docker ps
nomad node drain -enable 8593ceb2 # node ID
# container is now on another node
docker ps
# shows ineligible 
nomad node status
# Allocations section shows job is running on another node
nomad job status example
```
#### Enable the drained node, commands can be run from any node
```
nomad node eligibility -enable 8593ceb2 # node ID
# shows eligible again
nomad node status
```
