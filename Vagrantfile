Vagrant.configure("2") do |config|

  config.vm.define "k8s-master" do |server|
    server.vm.box = "debian/bullseye64"
    server.vm.hostname = "k8s-master"
    server.vm.network "private_network", ip: "192.168.121.103"
    server.vm.synced_folder '.', '/vagrant', disabled: true # disable default binding

    server.vm.provider :libvirt do |domain|
      domain.memory = 1600
      domain.cpus = 1
    end

  end

  config.vm.define "k8s-node1" do |server|
    server.vm.box = "debian/bullseye64"
    server.vm.hostname = "k8s-node1"
    server.vm.network "private_network", ip: "192.168.121.104"
    server.vm.synced_folder '.', '/vagrant', disabled: true # disable default binding

    server.vm.provider :libvirt do |domain|
      domain.memory = 1100
      domain.cpus = 1
    end

  end
end