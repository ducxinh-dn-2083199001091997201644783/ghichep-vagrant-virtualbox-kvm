#Đồng bộ dữ liệu giữa máy thực và VM.

- Mặc định thì `Vagrant` đã cho chúng ta một thư đồng bộ giữa máy chủ vậy lý và máy ảo.

- Ở trên máy chủ vật lý thư mục đó chính là thư mục chứa `Vagrantgile` còn trên VM nó nằm trong `/vagrant`

### Chúng ta thực hiện test thử :

- Đầu tiên chúng ta ssh vào VM và di chuyển đến thư mục `/vagrant` :

```sh
cd /vagrant
```

- Thực hiện lệnh sau :

```sh
echo "datpt" >> test_sync.txt
```

- Sau đó exit khỏi VM.

- Kiểm tra xem file đó đã có trên máy thực chưa và nội dung ra sao:

```sh
ls
cat test_sync.txt
```

![scr1](http://i.imgur.com/2cTCz73.png)

- Tiếp tục tại đây ta thực hiện lệnh :

```sh
echo "datpt" >> sync.txt
```

- Tiến hành đăng nhập vào VM.

- Di chuyển đến thư mục `/vagrant` và show file đó lên :

```sh
cd /vagrant
cat sync.txt
```

- Kết quả chúng ta có thể thu được :

![scr3](http://i.imgur.com/DZ8VclD.png)