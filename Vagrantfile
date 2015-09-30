# -*- mode: ruby -*-
# vi: set ft=ruby :
docker_setup_script = <<-SCRIPT
rm -rf /etc/docker/key.json

export PRIVATE_IP=`/sbin/ifconfig eth1 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`

echo DOCKER_OPTS=\\"-H tcp://$PRIVATE_IP:2375 -H tcp://127.0.0.1:2375 -H unix:///var/run/docker.sock --insecure-registry docker.env.xing.com\\" > /etc/default/docker

groupadd docker

gpasswd -a vagrant docker

service docker restart
SCRIPT

consul_master_script = <<-SCRIPT.strip
echo Installing consul...

export PRIVATE_IP=`/sbin/ifconfig eth1 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`

export BRIDGE_IP=172.17.42.1 # Change if you're using a non-default docker bridge

docker run -d --name consul -h $HOSTNAME \
    --restart always \
    -p $PRIVATE_IP:8300:8300 -p $PRIVATE_IP:8301:8301 -p $PRIVATE_IP:8301:8301/udp \
    -p $PRIVATE_IP:8302:8302 -p $PRIVATE_IP:8302:8302/udp -p $PRIVATE_IP:8400:8400 \
    -p $PRIVATE_IP:8500:8500 -p $BRIDGE_IP:53:53/udp \
    progrium/consul -server -advertise $PRIVATE_IP
SCRIPT

registrator_script = <<SCRIPT
echo Installing registrator...

export PRIVATE_IP=`/sbin/ifconfig eth1 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`

docker run -d --name registrator \
    --restart always \
    -v /var/run/docker.sock:/tmp/docker.sock \
    -h $HOSTNAME gliderlabs/registrator consul://$PRIVATE_IP:8500
SCRIPT

swarm_node_script = <<SCRIPT
echo Installing swarm-node...

export PRIVATE_IP=`/sbin/ifconfig eth1 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`

docker run -d --restart always --name swarm-node swarm --debug join --addr=$PRIVATE_IP:2375 consul://$PRIVATE_IP:8500/swarm
SCRIPT

swarm_manager_script = <<SCRIPT
echo Installing swarm-manager...

export PRIVATE_IP=`/sbin/ifconfig eth1 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`

docker run -d --name swarm-manager --restart always -p 12375:2375 swarm --debug manage consul://$PRIVATE_IP:8500/swarm
SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "dias_jorge/discovery-demo"

  config.vm.provision "shell", inline: docker_setup_script

  config.vm.define "n1" do |n1|
    n1.vm.hostname = "n1"
    n1.vm.network "private_network", ip: "172.20.20.10"
    n1.vm.network "forwarded_port", guest: 8500, host: 8500
    n1.vm.provision "shell", inline: (consul_master_script + " -bootstrap-expect 3 -ui-dir /ui")
    n1.vm.provision "shell", inline: registrator_script
    n1.vm.provision "shell", inline: swarm_node_script
    n1.vm.provision "shell", inline: swarm_manager_script
  end

  config.vm.define "n2" do |n2|
    n2.vm.hostname = "n2"
    n2.vm.network "private_network", ip: "172.20.20.11"
    n2.vm.provision "shell", inline: (consul_master_script + " -join 172.20.20.10")
    n2.vm.provision "shell", inline: registrator_script
    n2.vm.provision "shell", inline: swarm_node_script
  end

  config.vm.define "n3" do |n3|
    n3.vm.hostname = "n3"
    n3.vm.network "private_network", ip: "172.20.20.12"
    n3.vm.provision "shell", inline: (consul_master_script + " -join 172.20.20.10")
    n3.vm.provision "shell", inline: registrator_script
    n3.vm.provision "shell", inline: swarm_node_script
  end
end
