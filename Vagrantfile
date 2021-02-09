# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |a|
  a.vagrant.plugins = ['vagrant-vbguest']

  a.vm.hostname = 'ownreality'

  a.vm.provision "shell", run: "always", inline: 'modprobe vboxsf || true'

  a.vm.synced_folder '.', '/vagrant', type: 'virtualbox'

  # a.vm.network :forwarded_port, host: 3000, guest: 3000, host_ip: '127.0.0.1' # pandora
  a.vm.network :forwarded_port, host: 3306, guest: 3306, host_ip: '127.0.0.1' # mariadb
  a.vm.network :forwarded_port, host: 9200, guest: 9200, host_ip: '127.0.0.1' # elasticsearch
  a.vm.network :forwarded_port, host: 9222, guest: 9222, host_ip: '127.0.0.1' # headless chrome

  a.vm.provider :virtualbox do |vb|
    vb.name = 'ownreality'
    vb.memory = 2048
    vb.cpus = 2
  end

  a.vm.define 'ownreality', primary: true do |c|
    c.vm.box = 'generic/debian10'
    c.vm.box_version = '1.9.20'

    c.vm.provider :virtualbox do |vb|
      vb.name = "ownreality"
    end

    c.vm.provision :shell, path: 'provision.sh', args: 'debian_basics'
    c.vm.provision :shell, path: 'provision.sh', args: 'install_rbenv', privileged: false
  end
end
