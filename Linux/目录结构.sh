
###############目录结构
/root #与开机有关
---/bin #常用可执行文件，如cat,chmod,chown..
---/boot #开机用
---/dev #周边设备
---/etc #系统配置文件，账号密码文档，启动文档
---/lib #开机时用到的库函数
---/media #可移除设备
---/mnt #挂载
---/opt #第三方软件
---/run #开机后的产生的信息
---/srv #网络服务数据
---/tmp #临时文件
---/home #使用者主文件夹
---/lib<qual> #如64位库函数
---/root #系统管理员的主文件夹
---/lost+found #文件系统发生错误时
---/proc #系统核心、进程信息
---/sys #核心与硬件信息


-/usr(unix software resource)与软件安装执行有关
---/bin/ #
---/lib/
---/local #系统管理员自行安装的软件
---/sbin/
---/share/ #只读文件，说明文档
---/games/ #游戏相关
---/include #头文件
---/libexec #可执行脚本
---/src/ #一般源代码


-/var与系统运行有关
---/cache/ #缓存
---/lib/ #程序本身执行过程中需要的数据文件，如Mysql数据
---/lock/
---/log/ #重要！登陆文件
---/mail/
---/run/ #程序和服务的pid信息
---/spool/ #工作调度信息
