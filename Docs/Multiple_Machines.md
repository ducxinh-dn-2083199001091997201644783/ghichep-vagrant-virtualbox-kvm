#Tạo nhiều máy ảo cùng một lúc, trong đó chúng ta cần set card mạng host only cho từng máy cũng như forword port cho chúng.

- Trước tên chúng ta tạo một thư mục có tên `Multiple_machines` và di chuyển vào đó :

```sh
mkdir Multiple_machines
cd Multiple_machines
```

- Khởi tại Vagrantfile bằng lệnh :

```sh
vagrant init
```

- Chỉnh sửa file Vagrantfile:

```sh
vi Vagrantfile
```

- Sau đó chỉnh sửa lại file cấu hình như sau :

```sh
# Tạo Multiple_machines.
Vagrant.configure("2") do |config|
# Config VM 1.
  config.vm.define "web" do |web|
    web.vm.box = "ubuntu/trusty64"
    web.vm.hostname = "web"
    web.vm.box_url = "ubuntu/trusty64"
# Đặt địa chỉ host_only là 10.10.10.2
    web.vm.network :private_network, ip: "10.10.10.2", virtualbox__intnet: "vboxnet0"

    config.vm.network :forwarded_port, guest: 22, host: 1000
   end
#end

# Config VM 2
  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/trusty64"
    db.vm.hostname = "db"
    db.vm.box_url = "ubuntu/trusty62"

    db.vm.network :private_network, ip: "10.10.10.3", virtualbox__intnet: "vboxnet0"

    config.vm.network :forwarded_port, guest: 22, host: 1001
   end
end
```

- Sau khi tạo xong file cấu hình với nội dung như trên chúng ta thực hiện tạo VM:

```sh
vagrant up
```

- Kiểm tra xem các máy ảo đã được tạo hoàn tất và bật lên chưa bằng lệnh:

```sh
vagrant status
```

![scr2](http://i.imgur.com/kmWaZCJ.png)

- Ở đây ta thấy 2 VM của chúng ta đã được tạo và bật lên thành công.

- Bây giờ tiến hành SSH vào từng máy để kiểm tra chúng ta sử dụng lệnh:

```sh

# Để ssh vào VM 1 (web)
vagrant ssh web

# Để ssh vào VM 2 (db)
vagrant ssh db 
```

- Nếu như gặp tình trạng 1 trong 2 máy off hoặc của 2 thì chúng ta dùng lệnh sau để bật máy đó lên:

```sh
vagrant up web

# hoặc

vagrant up db
```

- Sau đây là kết quả kiểm tra :

###Tại VM 1 (web)

![scr3](http://i.imgur.com/UTSLZwX.png)

###Tại VM 2 (db)

![scr4](http://i.imgur.com/Lfco0bk.png)

- Sau khi sử dụng xong chúng ta nên tắt các VM đi bằng lệnh :

```sh
vagrant halt web

# hoặc

vagrant halt db
```