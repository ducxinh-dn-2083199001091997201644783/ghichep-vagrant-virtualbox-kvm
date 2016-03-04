### Các ghi chép về vagrant

#### Vagrant

- Mặc định khi sử dụng vagrant với virtual box sẽ có 1 NIC (thường là NIC đầu tiên) sử dụng NAT trong `virtualbox`

#### Virtualbox

- Các kiểu mạng trong `virtualbox`
```sh
NAT: 
 Mặc định có sẵn trong 1 NAT sau khi cài đặt virtualbox.
 Chỉ sử dụng cho máy local truy cập vào máy ảo. 
 Không setup trên đồ họa được.
 http://prntscr.com/ab3o35
 Sử dụng cơ chế NAT và forward port để truy cập vào máy ảo và máy ảo ra ngoài internet

NAT Network:
 Tương tự như NAT nhưng setup được bằng đồ họa. 
 Có thể thêm nhiều NAT Network
 http://prnt.sc/ab3nn3  http://prntscr.com/ab3ogw
 Sử dụng cơ chế NAT và forward port để truy cập vào máy ảo và máy ảo ra ngoài internet
 
Hostonly: 
 Tương tự VMwareworkstation
 Dùng để các máy ảo truyền thông với nhau.

Bridge
 Chế độ máy ảo sẽ có cùng IP với IP của card máy vật lý.

```




#### KVM (libvirt KVM)
