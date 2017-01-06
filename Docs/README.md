#Tìm hiểu về Vargrant.

```sh
Vargrant là gì?
```

- Là một công cụ giúp chúng ta có thể thiết lập và cấu hình môi trường dev một cách nhanh chóng , gọn nhẹ.
- Điều quan trọng nhất nó là mã nguồn mơr => Free.
- Nó có thể tự động tạo ra máy ảo sử dụng Oracle's vitualbox.
- Là một sản phẩm được viết bằng Ruby.
- Nó là một giải pháp tự động dễ dàng tương tác với vitualbox từ Oracle.
- Nó cài đặt một máy ảo mới dựa trên Box được cấu hình sẵn và được quy định trong VargrantFile.
- Các IP tĩnh được gán cho máy ảo có thể truy cập từ bên ngoài.
- Các port cần thiết có thể được thiết lập để truy cập.
- Khi một công việc được thực hiện , môi trường có thể bị phá hủy hoặc loại bỏ.

```sh
Vargrant và những lợi ích nó đem lại.
```

- Giảm thiểu thời gian thiết lập.
- Thực hiện dễ dàng và đơn giản.
- Tự phục vụ, dựa trên Pull của một Base Box nào đó (Mỗi VM được dựa trên một basebox).
- CÓ khả năng lặp lại (Một VM mới có thể được khởi tạo hoặc loại bỏ trong một vài phút).

```sh
Mô tả cách hoạt động .
```

![Vargrant](http://i.imgur.com/u2kwkeI.jpg)

##Tạo máy ảo từ Vargrant.

- Để tạo được máy ảo bằng Vargrant thì trên máy tính của chúng ta cần có vitualbox và Vargrant.

- Cách cài đặt vitualbox chúng ta có thể xem tại [đây](https://www.sitecuatui.com/cai-dat-virtualbox-tren-ubuntu-centos/)

- Sau khi cài đặt xong Vitualbox chúng ta cần cài đặt Vargrant, công việc này cũng khá đơn giản, chúng ta tải 
Vargrant từ [trang chủ](https://www.vagrantup.com/downloads) và cài đặt bình thường.

- Sau khi quá trình cài đặt hoàn tất chúng ta mở terminal lên (Ctrl + Alt + T) và gõ :

```sh
vagrant
```

- Sau đó chúng ta tạo file `vagrant_sample` :

```sh
mkdir vagrant_sample
cd vagrant_sample
```

- Sau đó chúng ta dùng lệnh:

```sh
vagrant init
```

- Lệnh này giúp chúng ta khở tạo ra 1 file đó là `Vagrantfile` File này có 2 việc: 1 là chỉ định root directory cho project của bạn, các setup sau này sẽ được tính toán relative path từ Vagrantfile. 2 là setting cho toàn project, bao gồm OS, distribution, resources và các phần mềm được cài đặt cũng như cách access vào machine. Đây là 1 file được viết bằng Ruby (mặc dù không có đuôi .rb).

- Mỗi máy ảo được tạo ra đề dựa vào 1 Boxes, các boxes này được cung cấp tại [đây](https://atlas.hashicorp.com/boxes/search) chúng ta có thể tham khảo và tải các boxes cần thiết về máy để có thể dễ dàng cài đặt masy ảo theo như cầu một cách nhanh nhất.

- Ở đây mình sẽ tải Ubuntu 12.02-32bit :

```sh
vagrant box add hashicorp/precise32
```

- Vagrant sẽ tự động tìm box với tên hashicorp/precise32 từ [HashiCorp’s Atlas box catalog](https://atlas.hashicorp.com/boxes/search) và download box này về máy tính của bạn. Đây là box có thể tái sử dụng trong nhiều project. Mỗi khi 1 project mới được tạo từ box này, vagrant sẽ tự động copy ra 1 image khác, mọi chỉnh sửa sẽ không ảnh hưởng đến base box. Để set box cho project của bạn, bạn cần edit file Vagrantfile. Mở file `Vagrantfile`

```sh
vi Vargrantfile
```

- Tìm đến dòng `config.vm.box = "base"` và sửa thành :

```sh
config.vm.box = "hashicorp/precise32"
```

- Lưu file lại và tiến hành tạo máy ảo bằng lênh:

```sh
vagrant up
```

- Khi quá trình tạo VM kết thúc chúng ta có một máy Ubuntu trên Vitualbox nhận địa chỉa IP NAT được DHCP từ Vitualbox, để kiểm tra chúng ta thực hiện SSH vào VM đó :

```sh
vagrant ssh
```

- kết quả chúng ta nhận được khi kiểm tra địa chỉ IP như sau :

![scr1](http://i.imgur.com/ZD0ZyEm.png)

- Tuy nhiên như thế chúng ta tạo máy ảo với card mạng NAT và không có địa chỉ IP như mong muốn. Ở đây mình sẽ tiến hành tạo máy ảo đó với 2 card mạng NAT và hostonly (10.10.10.0/24) và eth1 nhận địa chỉ 10.10.10.10.

- Trước tên chúng ta tạo một vboxnet với tên "vboxnet0" có dải 10.10.10.0/24

- Sau đó chúng ta mở file `Vagrantfile`  , tìm đến dòng : ` config.vm.network "private_network", ip: "x.x.x.x",` và sửa lại như sau:

```sh
 config.vm.network "private_network", ip: "10.20.10.69",
  virtualbox__intnet: "vboxnet0"
```

- Sau đó thực hiện tạo máy ảo và SSH vào để kiểm tra:

```sh
vagrant up
vagrant ssh
```

- Kết quả chúng ta thu được như sau :

![scr2](http://i.imgur.com/EGktbNW.png)
#Nguồn:
- https://viblo.asia/dinhhoanglong91/posts/1l0rvmDQGyqA
- https://atlas.hashicorp.com/boxes/search
- https://www.vagrantup.com/docs/networking/index.html
- https://dzone.com/articles/introduction-vagrant
