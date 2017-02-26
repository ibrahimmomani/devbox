VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Configure The Box
  config.vm.box = 'bento/ubuntu-16.04'
  config.vm.hostname = "devbox"

  # Don't Replace The Default Key https://github.com/mitchellh/vagrant/pull/4707
  config.ssh.insert_key = false
  config.ssh.forward_agent = true
  
  
  # Configure A Private Network IP
  config.vm.network :private_network, ip: "192.168.10.10"

  config.vm.provider :virtualbox do |vb|
    vb.name = "devbox"
    vb.customize ["modifyvm", :id, "--memory","2048"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1","on"]
    vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
  end

  # Configure Port Forwarding
  config.vm.network 'forwarded_port', guest: 80, host: 8000, auto_correct: true
  config.vm.network 'forwarded_port', guest: 27017, host: 27017, auto_correct: true
  config.vm.network 'forwarded_port', guest: 6379, host: 63790, auto_correct: true


  config.vm.synced_folder './', '/vagrant', mount_options: ["dmode=755", "fmode=666"]
  config.vm.synced_folder "../www", "/var/www/", mount_options: ["dmode=755", "fmode=775"]
  
  if File.file?(File.expand_path("~/.gitconfig"))
    config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
  end
  
  # Configure The Public Key For SSH Access
  if File.exists? File.expand_path("~/.ssh/id_rsa.pub")
    config.vm.provision "shell" do |s|
      s.inline = "echo $1 | grep -xq \"$1\" ~/.ssh/authorized_keys || echo $1 | tee -a /home/vagrant/.ssh/authorized_keys"
      s.args = [File.read(File.expand_path("~/.ssh/id_rsa.pub"))]
    end
  end
    
  # Copy The SSH Private Keys To The Box
  ["~/.ssh/id_rsa"].each do |key|
    config.vm.provision "shell" do |s|
      s.privileged = false
      s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
      s.args = [File.read(File.expand_path(key)), key.split('/').last]
    end
  end

  # Copy file from host to guest.
  if File.file?(File.expand_path("./tools/other/aliases"))
      config.vm.provision "file", source: "./tools/other/aliases", destination: ".bash_aliases"
  end

  config.vm.provision 'shell', path: './scripts/update.sh'
  config.vm.provision :reload
  config.vm.provision 'shell', path: './scripts/provision.sh'

end
