Vagrant.configure("2") do |config|

  if Vagrant.has_plugin? "vagrant-vbguest"
    config.vbguest.no_install  = true
    config.vbguest.auto_update = false
    config.vbguest.no_remote   = true
  end

  config.vm.define :servidorWeb1 do |servidorWeb1|
    servidorWeb1.vm.box = "bento/ubuntu-22.04"
    servidorWeb1.vm.network :private_network, ip: "192.168.100.10"
    servidorWeb1.vm.hostname = "servidorWeb1"

    servidorWeb1.vm.synced_folder "./Files", "/home/vagrant/SyncFolder", type:"virtualbox"

    servidorWeb1.vm.provision "shell", path: "provisionServidorWeb.sh"
    servidorWeb1.vm.provision "shell", inline: 'sudo cp SyncFolder/AppWeb1/index.js app/'
    servidorWeb1.vm.provision "shell", inline: <<-SHELL
      sudo pkill consul
      sudo nohup consul agent -ui -dev -bind=192.168.100.10 -client=0.0.0.0 -data-dir=. &
      sleep 5
      sudo pkill node
      sudo nohup node app/index.js 3000 &
      sudo nohup node app/index.js 3001 &
    SHELL
  end

  config.vm.define :servidorWeb2 do |servidorWeb2|
    servidorWeb2.vm.box = "bento/ubuntu-22.04"
    servidorWeb2.vm.network :private_network, ip: "192.168.100.11"
    servidorWeb2.vm.hostname = "servidorWeb2"

    servidorWeb2.vm.synced_folder "./Files", "/home/vagrant/SyncFolder", type:"virtualbox"

    servidorWeb2.vm.provision "shell", path: "provisionServidorWeb.sh"
    servidorWeb2.vm.provision "shell", inline: 'sudo cp SyncFolder/AppWeb2/index.js app/'
    servidorWeb2.vm.provision "shell", inline: <<-SHELL
      sudo pkill consul
      sudo nohup consul agent -ui -dev -bind=192.168.100.11 -client=0.0.0.0 -data-dir=. &
      sleep 5
      sudo pkill node
      sudo nohup node app/index.js 3002 &
      sudo nohup node app/index.js 3003 &
      sudo consul join 192.168.100.10
    SHELL
  end

  config.vm.define :balanceadorHAP do |balanceadorHAP|
    balanceadorHAP.vm.box = "bento/ubuntu-22.04"
    balanceadorHAP.vm.network :private_network, ip: "192.168.100.12"
    balanceadorHAP.vm.hostname = "balanceadorHAP"

    balanceadorHAP.vm.synced_folder "./Files", "/home/vagrant/SyncFolder", type:"virtualbox"

    balanceadorHAP.vm.provision "shell", path: "provisionBalanceadorHAP.sh"
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize [ 'modifyvm', :id, '--memory', '1024' ]
    vb.customize [ 'modifyvm', :id, '--cpus', '4' ]
  end
end