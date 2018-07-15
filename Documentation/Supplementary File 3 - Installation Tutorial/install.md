<!-- <meta http-equiv="refresh" content="2"> -->
<script type="text/javascript"
 src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

目录  

[TOC]  
******
# Docker Install
### Docker Install in centos 7
    sudo yum install docker    
### Start Docker Service
    sudo service docker start # 启动start,重启动restart，停止stop
### 测试是否正确安装
    sudo docker run hello-world
### 建立docker用户组
建立docker用户组，使得普通用户不需要sudo权限，即能使用docker。  
参考：http://blog.csdn.net/he_wolf/article/details/37796285  

    # 如果没有docker用户组，则建立docker用户组  
    sudo groupadd docker
    # 将用户XXX加入该group内。然后退出并重新登录就生效
    sudo gpasswd -a XXX docker
    #重启Docker
    sudo service  docker restart
    #退出shell重新登录用户

# Docker Using
### Load image from file 
    docker load --input docker_save.tar
### Save image to file 
    docker save -o docker_save.tar hca:latest
### List all the images/containers
    docker images # list all the images
    docker ps -a # list all the containers
### Remove image or container
    docker rmi <image id>   # rmi means "remove image"
    docker rm <container id> 
### Run image 
    docker run -i -t -d --name tmp -v /driver/path:/container/path  --privileged=true [images ID; image name:TAG] command
* -i -t :表示交互并且有界面
* -d : 表示有台运行
* --name: 将容器命名为tmp
* -v : 将宿机的/driver/path挂在到容器的/container/path路径下
* --privileged=true： 如果数据卷有权限问题，出现permission denied，需要加上此参数
    参考： http://blog.csdn.net/buyaore_wo/article/details/78062931
* command:运行的命令，比如"bash"

# 转移hca:latest 镜像
* 从服务器中保存hca:latest 镜像

        docker save -o hca_latest.tar hca:latest  

* 传输到新服务器
* 在新服务器读取hca:latest镜像  

        docker load --input hca_latest.tar  

* 查看所有镜像  

        docker images  

* 测试运行镜像  

        docker run --rm -v /tmp:/data --privileged=true  hca:latest  echo "hello world!"

* 正常使用

# Trobule shooting
1. 报错： sudo service docker start 启动不了守护进程  
    参考： https://stackoverflow.com/questions/39100641/docker-service-start-failed  

        rm -rf /var/lib/docker #删除不了则用ps -ef|grep docker ,强制kill 活动进程
        vim /etc/docker/daemon.json
        改为：  
        { "graph": "/mnt/docker-data", "storage-driver": "overlay" }  

2. 报错： ApplyLayer exit status 1 stdout:  stderr:   no space left on device  
    原因：大概是因为container的rootfs 大小不够导致  
    参考: http://www.alliedjeep.com/4949.htm   
    方法：   

        docker run --rm hca:py2 df -lhT  #可看到 rootfs不够20G
        sudo service docker stop 
        sudo rm  -rf  /var/lib/docker #此步骤会删除所有docker相关的东西，比如镜像之类，务必先保存好镜像
        dockerd  --storage-opt dm.basesize=30G   #如果一直没有退出，当出现 INFO[0001] API listen on /var/run/docker.sock 应该就可以强制断掉
        sudo  service docker  start 
        docker run --rm hca:py2 df -lhT  #可看到 rootfs已经改为30G  
 



