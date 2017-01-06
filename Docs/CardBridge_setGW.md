#Cách tạo máy ảo với card Bridge và set default gateway về gateway của dải Bridge.

- Để tại được máy ảo với yêu cầu như trên chúng ta thực hiện chỉnh sửa file cấu hình `Vagrantfile` như sau:

```sh
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # Ở đây chúng ta đặt bridge: với tên của các mạng mà chúng ta lựa chọn nhận địa chỉ của card bridge, ip là ip củ máy vật lý
  config.vm.network "public_network", bridge: "eth0", ip: "10.145.25.227"

  #set inline với địa chỉ của gateway mà chúng ta muốn set.
  config.vm.provision "shell",
    run: "always",
    inline: "route add default gw 10.145.25.1"

end
```

- Sau khi chỉnh sửa file cấu hình như trên chúng ta thực hiện chạy lệnh để tạo máy ảo :

```sh
vagrant up
```

- Sau đó chúng ta thực hiện SSH vào để kiểm tra sự thay đổi :

```sh
vagrant ssh
```

- Kết quả mà chúng ta thu được như sau :

![scr1](http://i.imgur.com/nbUhTNo.png)

- Nếu như chúng ta muốn xóa bỏ default GW tại card mạng đó thì chúng ta thực hiện thêm các option sau vào file cấu hifnnh :

```sh
config.vm.provision "shell",
  run: "always",
  inline: "eval `route -n | awk '{ if ($8 ==\"eth0\" && $2 != \"0.0.0.0\") print \"route del default gw \" $2; }'`"
end
```