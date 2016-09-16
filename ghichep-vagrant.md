# Ghi chép Vagrant - Virtualbox - KVM

## Cài đặt Vagrant - Virtualbox - KVM

- Môi trường chuẩn bị

    ```sh
    root@c-vagrant:~# lsb_release -a
    No LSB modules are available.
    Distributor ID: Ubuntu
    Description:    Ubuntu 14.04.5 LTS
    Release:        14.04
    Codename:       trusty
    ```


- Cài đặt  Virtualbox, Vagrant trên Ubuntu 14.04

    ```sh
    sudo apt-get -y install virtualbox
    sudo apt-get -y install vagrant
    sudo apt-get -y install virtualbox-dkms
    ```

- Tải image của virtualbox về thư mục `/root/`

    ```sh
    wget https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box
    ```

- Add image 

    ```sh
    vagrant box add ubuntu/trusty64 virtualbox.box
    ```

- Tạo file `Vagrantfile`

    ```sh
    vagrant init ubuntu/trusty64
    ```

- Tạo máy ảo `ubuntu/trusty64`

    ```sh
    vagrant up
    ```

- Kết quả: http://prntscr.com/cikzgu

- Kiểm tra tình trạng tạo máy ảo (kết quả báo running)

    ```sh
    root@c-vagrant:~# vagrant status
    Current machine states:

    default                   running (virtualbox)

    The VM is running. To stop this VM, you can run `vagrant halt` to
    shut it down forcefully, or you can run `vagrant suspend` to simply
    suspend the virtual machine. In either case, to restart it again,
    simply run `vagrant up`.
    root@c-vagrant:~#
    ```


- Truy cập vào máy ảo 

    ```sh
    vagrant ssh
    ```

- Kết quả: http://prntscr.com/cikzba




