#############################################
###################################IP地址配置
#ifconfig 命令临时配置IP地址，重启失效

ifconfig #查看网络信息
ifconfig eth0 192.168.254.100 netmask 255.255.255.0 #临时配置IP和子网掩码

#修改网络配置文件
#网卡信息文件
vim /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE = eth0 #网卡设备名
BOOTPROTO = none #是否自动获取ip(none\static\dhcp)
HWADDR = 00:0c:29:17:c4:09 #MAC地址
ONBOOT = yes #是否随网络服务启动，eth0生效
TYPE = Ethernet # 类型为以太网
IPADDR = 192.168.0.252 # ip 地址
NETMASK = 255.255.255.0 #子网掩码
GATEWAY = 192.168.0.1 # 网关
DNS1 = 202.106.0.20 # DNS
USERCTL = no # 不允许非root用户控制此网卡

#主机名文件
vim /etc/sysconfig/network

#DNS文件
vim /etc/resolv.conf

#########################################
############################## 查看网络状态
ifdown eth0 #禁用eth0 这个网卡
ifup eth0 #启用eth0这个网卡

netstat -tunla #查询网络状态，开了哪些端口
-t #列出tcp协议端口
-u #列出udp协议端口
-n #不使用域名与服务名，而使用ip地址和端口号
-l #仅列出在监听状态网络服务
-a # 列出所有网络连接

netstat -an |grep ESTABLISHED | wc -l #查询当前有多少人连接到本服务器

netstat -rn # 查询当前路由状态

#查询DNS信息
nslookup www.baidu.com #进行域名解析
nslookup
>server 
# 查看本机DNS服务器

############################################
############################## 网络测试
ping 192.168.0.125 -c #测试能否连接这个ip,ping c次

telnet 192.168.0.252 80 # 探测这个ip的80端口是否打开

traceroute 192.168.0.252 # 路由跟踪，查看访问这个ip经过了那些网关

wget 网址 #下载命令





