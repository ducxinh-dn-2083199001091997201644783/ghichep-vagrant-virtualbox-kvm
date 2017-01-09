#Sau đây là bài demo kết hợp Vagrant và Ansible.

###1. vagrant là gì?

- Là một công cụ giúp chúng ta có thể thiết lập và cấu hình môi trường dev một cách nhanh chóng , gọn nhẹ.
- Điều quan trọng nhất nó là mã nguồn mơ => Free.
- Nó có thể tự động tạo ra máy ảo sử dụng Oracle's vitualbox.
- Là một sản phẩm được viết bằng Ruby.
- Nó là một giải pháp tự động dễ dàng tương tác với vitualbox từ Oracle.
- Nó cài đặt một máy ảo mới dựa trên Box được cấu hình sẵn và được quy định trong VargrantFile.
- Các IP tĩnh được gán cho máy ảo có thể truy cập từ bên ngoài.
- Các port cần thiết có thể được thiết lập để truy cập.
- Khi một công việc được thực hiện , môi trường có thể bị phá hủy hoặc loại bỏ.

###2. Ansible là gì?

- Ansible đang là công cụ Configuration Management khá nổi bật hiện nay.
- Là công cụ mã nguồn mở dùng để quản lý cài đặt, cấu hình hệ thống một cách tập trung và cho phép thực thi câu lệnh điều khiển.
- Sử dụng SSH (hoặc Powershell) và các module được viết bằng ngôn ngữ Python để điểu khiển hệ thống.
- Sử dụng định dạng JSON để hiển thị thông tin và sử dụng YAML (Yet Another Markup Language) để xây dựng cấu trúc mô tả hệ thống.
- Không cần cài đặt phần mềm lên các agent, chỉ cần cài đặt tại master.
- Không service, daemon, chỉ thực thi khi được gọi.
- Bảo mật cao ( do sử dụng giao thức SSH để kết nối )
- Cú pháp dễ đọc, dễ học, dễ hiểu.

##Mô hình thực hiện và yêu cầu bài lab.

- Bài lab thực hiện tự động cài đặt 2 VM có hệ điều hành Ubuntu 14.04 và trên 2 máy đó khi cài xong sẽ tự động cấu hình web server trên một máy và 1 máy sẽ tự đọng cấu hình DB server.

- Yêu cầu : 
 <ul>
  <li>Trên máy web server có cài đặt Apache2, Wordpress, PHP5.</li>
  <li>Trên máy DB server có cài MySQL server.</li>
  <li>Sau khi chạy xong thì máy web server có thể liên kết với máy DB server để chạy wordpress.</li>
 </ul>

```sh

|                                                                      |-------| Ubuntu 14.04 (Web server) - 26.26.26.26/24
|                                   |------------| Vagrant-------------|
|                                   |                                  |-------| Ubuntu 14.04 (DB server) - 26.26.26.27/24
|                                   |
|---| (Ubuntu 14.04 Desktop)--------|
|                                   |
|                                   |                                 |--------| web.yml
|                                   |                                 |
|                                   |------------| Ansible------------|--------| db.yml
|                                                                     |
|                                                                     |--------| hosts

```

### Lưu ý.

- Bài lab được thực hiện trên máy tính có hệ điều hành Ubuntu 14.04 (Desktop) có cài đặt Virtualbox và thực hiện dưới quyền ROOT.

### Thực hiện.

- Trên máy tính vật lý chúng ta tiến hành cài đặt Virtualbox theo [hướng dẫn](https://www.sitecuatui.com/cai-dat-virtualbox-tren-ubuntu-centos/)

- Sau đó chúng ta tiến hành cài đặt `Vagrant` và `Ansible`.

#### Cài đặt vagrant:

- Tải vagrant tại [đây](https://www.vagrantup.com/downloads) và cài đặt bình thường.

- Sau khi hoàn tất quá trình cài đặt chúng ta gỡ lệnh `vagrant` để kiểm tra.

```sh
vagrant
```

- Kết quả như hình bên dưới là bạn đã thành công.

![scr1](http://i.imgur.com/KObOjf0.png)

- Tiếp theo chúng ta cài đặt `Ansible`

```sh
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
```

- Sau khi cài đặt xong Ansible chúng ta tiến hành tạo playbook cấu hình web và db.

- Tạo playbook cấu hình cho web.

```sh
vi /etc/ansible/web.yml
```

- Sau đó coppy đoạn YAML sau vào playbook `web.yml`

```sh
- hosts: webservers
  sudo: yes
  tasks:
  - name: INSTALL APACHE2
    apt: name=apache2 update_cache=yes
  - name: CONFIG VIRTUAL HOST WordPress
    lineinfile:
      dest=/etc/apache2/sites-available/000-default.conf
      regexp="DocumentRoot /var/www/html"
      line="DocumentRoot /var/www/wordpress"
  - name: INSTALL PHP5
    apt: name={{item}} update_cache=yes
    with_items:
      - php5
      - libapache2-mod-php5
      - php5-mcrypt
      - php5-mysqlnd-ms
  - name: DOWNLOAD WordPress
    get_url:
      url=https://wordpress.org/latest.tar.gz
      dest=/tmp/wordpress.tar.gz
      validate_certs=no
  - name: EXTRACT WordPress
    unarchive:
      src=/tmp/wordpress.tar.gz
      dest=/var/www/
      copy=no
  - name: COPY FILE CONFIG Wordpress
    command: mv /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
  - name: FILE CONFIG Wordpress
    lineinfile:
      dest=/var/www/wordpress/wp-config.php
      regexp="{{ item.regexp }}"
      line="{{ item.line }}"
    with_items:
      - {'regexp': "define\\('DB_NAME', '(.)+'\\);", 'line': "define('DB_NAME', 'wordpress');"}
      - {'regexp': "define\\('DB_USER', '(.)+'\\);", 'line': "define('DB_USER', 'wordpress');"}
      - {'regexp': "define\\('DB_PASSWORD', '(.)+'\\);", 'line': "define('DB_PASSWORD', 'wordpress');"}
      - {'regexp': "define\\('DB_HOST', '(.)+'\\);", 'line': "define('DB_HOST', '26.26.26.27');"}
  - name: RESTART APACHE2
service: name=apache2 state=restarted
```

### Lưu ý : Chỉnh lại DB_HOST thành IP của DB server mà chúng ta triển khai, ở đây là 26.26.26.27

- Sau đó chúng ta tạo playbook cấu hình cho DB server :

```sh
vi /etc/ansible/db.yml
```

- Sau đó coppy đoạn YAML sau vào playbook `db.yml`

```sh
---
- hosts: dbservers
  sudo: yes
  tasks:
  - name: INSTALL MYSQL
    apt: name={{item}} update_cache=yes
    with_items:
      - mysql-server
      - python-mysqldb
  - name: CREATE DATABASE WordPress
    mysql_db: name=wordpress
  - name: CREATE USER FOR DATABASE WordPress
    mysql_user: name=wordpress password=wordpress priv=wordpress.*:ALL host=26.26.26.26
  - name: CONFIG MYSQL For Remote DB
    lineinfile:
      dest=/etc/mysql/my.cnf
      regexp="bind-address"
      line="bind-address = 0.0.0.0"
  - name: RESTART MYSQL Server
service: name=mysql state=restarted
```

### Lưu ý : Sửa host=26.26.26.26 thành IP của web server mà bạn dự định triển khai, ở đây là 26.26.26.26

- Sau đó tùy chỉnh Inventory hay còn gọi là chỉnh file `hosts`, thực hiện các lệnh sau :

```sh
echo [webservers] >> /etc/ansible/hosts
echo 26.26.26.26 >> /etc/ansible/hosts
echo [dbservers] >> /etc/ansible/hosts
echo 26.26.26.27 >> /etc/ansible/hosts
```

### Lưu ý : Các IP của web server và DB server chúng ta phải đổi lại theo mô hình mà chúng ta triển khai.

- Tiếp theo chúng ta cần cấu hình `Vagrant`

- Để có thể tự động cài đặt HĐH chúng ta cần dowload các boxes về, chi tiết các box xem tại [đây](https://atlas.hashicorp.com/boxes/search) . Ở bài lab này yêu cầu dùng HĐH Ubuntu server 14.04 cho nên mình sẽ dùng box `ubuntu/trusty64`, tiến hành dowload về máy tính :

```sh
vagrant box add ubuntu/trusty64
```

- Sau khi tải xong box chúng ta tạo một thư mục để lưu trữ máy ảo mà chúng ta sẽ tạo ra.

```sh
mkdir VM_vagrant
cd VM_vagrant
```

- Sau đó chúng ta gõ lệnh sau để tiến hành tạo ra file cấu hình máy ảo :

```sh
vagrant init
```

- Sau khi thực hiện `vagrant init` chúng ta được tạo ra 1 file có tên là `Vagrantfile`. Chúng ta tiến hành cấu hình file này để có thể tự động tạo được HĐH cũng như móc nối với Ansible để có thể tự động cấu hình dịch vụ:

```sh
vi Vagrantfile
```

- Sau đó chỉnh sửa lại file cấu hình như sau :

```sh
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  # config.vm.box = "ubuntu/trusty64"
  # config.ssh.insert_key = false

  # host web config
  config.vm.define "web" do |web|
    web.ssh.insert_key = false
    web.vm.box = "ubuntu/trusty64"
    web.vm.hostname = "web"
    web.vm.box_url = "ubuntu/trusty64"

    web.vm.network :private_network, ip: "26.26.26.26", virtualbox__hostonly: "vboxnet0"

    web.vm.provider "virtualbox" do |vb|
      vb.name = "web"
      vb.memory = 512
      vb.cpus = 2
    end

    web.vm.provision "ansible" do |ansible|
      ansible.playbook = "/etc/ansible/web.yml"
      ansible.inventory_path = "/etc/ansible/hosts"
      ansible.sudo = true
      ansible.limit = "all"
    end

    #config.vm.network :forwarded_port, guest: 22, host: 2626
  end

  # host db config
  config.vm.define "db" do |db|
    db.ssh.insert_key = false
    db.vm.box = "ubuntu/trusty64"
    db.vm.hostname = "db"
    db.vm.box_url = "ubuntu/trusty64"

    db.vm.network :private_network, ip: "26.26.26.27", virtualbox__hostonly: "vboxnet0"

    db.vm.provider "virtualbox" do |vb|
      vb.name = "db"
      vb.memory = 512
      vb.cpus = 2
    end

    db.vm.provision "ansible" do |ansible|
      ansible.playbook = "/etc/ansible/db.yml"
      ansible.inventory_path = "/etc/ansible/hosts"
      ansible.sudo = true
      ansible.limit = "all"
    end

    #config.vm.network :forwarded_port, guest: 22, host: 1234
  end

  #config.vm.provider "virtualbox" do |v|
  #  v.name = "web"
  #end
  #config.vm.hostname = "web"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
end
```

- Lưu ý : Chúng ta cấu hình IP cho máy ảo cũng như card mạng của máy ảo thông qua lệnh web.vm.network :private_network, ip: "26.26.26.26", virtualbox__hostonly: "vboxnet0" và db.vm.network :private_network, ip: "26.26.26.26", virtualbox__hostonly: "vboxnet0".

- Sau khi  các quá trình cấu hình kết thúc, chúng ta thực hiện lệnh sau :

```sh
vagrant up
```

- Sau đó đi pha cốc cafe rồi ngồi đợi kết quả thôi :D


- Kết quả sau khi quá trình cài đặt kết thúc :

![scr2](http://i.imgur.com/oERZRSs.png)Sau khi quá trình cài đặt trên Node web kết thúc.

![scr3](http://i.imgur.com/dRFL6Np.png)Sau khi quá trình cài đặt trên Node DB kết thúc.

![scr4](http://i.imgur.com/rYsDUiv.png)Kết quả khi vào web.

# Lưu ý :

- Trong quá trình thực hiện rất có thể phát sinh lỗi không mong muốn, nếu như phát hiện ra lỗi trong quá trình triển khai thì mong mọi người đóng góp với mình qua [Facebook](https://www.facebook.com/deutrau)

# Thanks For Reading !!!