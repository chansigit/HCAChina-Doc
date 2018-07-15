<!-- <meta http-equiv="refresh" content="2"> -->
<script type="text/javascript"
 src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

Content 

[TOC]  
******
# Docker install
### Docker Install in centos 7
    sudo yum install docker    
### Start docker service
    sudo service docker start 
### Test if docker installed sucessful
    sudo docker run hello-world
### Setup docker user group
A man who want to run docker command will need  sudo aceess. However, a common user can use docker without sudo access if he is in docker user group.  
Reference: http://blog.csdn.net/he_wolf/article/details/37796285  

    # generate a user group called docker 
    sudo groupadd docker
    # add user "XXX" to docker group
    sudo gpasswd -a XXX docker
    # restart Docker service
    sudo service  docker restart
    # sign out and sign in again 

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
* -i : Interactive 
* -t : Allocate a pseudo-TTY
* -d : Run container in background and print container ID
* --name : Assign a name to the container,such as "tmp"
* -v : Bind mount a volume. mount /driver/path in server \ to /container/path in container.
* --privileged=true : Give extended privileges to this container.When permission denied error arise,add this parameter.
    Reference： http://blog.csdn.net/buyaore_wo/article/details/78062931
* command : the command line you want to run in container,such as "echo hello world"

# Transport hca:latest image
* save hca:latest image from server

        docker save -o hca_latest.tar hca:latest  

* transport image to new server
* load hca:latest image to new server  

        docker load --input hca_latest.tar  

* list all the images

        docker images  

* test hca:latest image

        docker run --rm -v /tmp:/data --privileged=true  hca:latest  echo "hello world!"

* enjoy!

# Trobule shooting
1. "sudo service docker start" failed  
    Rerfence： https://stackoverflow.com/questions/39100641/docker-service-start-failed  

        rm -rf /var/lib/docker # if permission denied, use "ps -ef|grep docker" to kill all the process relate to docker
        vim /etc/docker/daemon.json
        cat /etc/docker/daemon.json
>   { "graph": "/mnt/docker-data", "storage-driver": "overlay" }  

2. "docker load --input hca_latest.tar "failed  
    Error just like： ApplyLayer exit status 1 stdout:  stderr:   no space left on device  
    Reason : probably becasuse rootfs of container is not lagre enough  
    Reference: http://www.alliedjeep.com/4949.htm   
    Solution：   

        docker run --rm hca:latest df -lhT  # rootfs is less than 20G,is no enought to load hca image
        sudo service docker stop 
        sudo rm  -rf  /var/lib/docker # this command will clear all information about runing docker service, so please save images first and etc. 
        dockerd  --storage-opt dm.basesize=30G   
        sudo  service docker  start 
        docker run --rm hca:latest df -lhT  # rootfs is set to 30G now  
 



