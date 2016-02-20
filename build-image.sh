#!/bin/bash

image=$1
tag="0.2.0"

if [ $# = 0 ]
then
	echo "Please use image name as the argument!"
	exit 1
fi

#docker respoistory name
respoistory=mafzaal

# founction for delete images
function docker_rmi()
{
	echo -e "\n\ndocker rmi $respoistory/$1:$tag"
	docker rmi $respoistory/$1:$tag
}


# founction for build images
function docker_build()
{
	cd $1
	echo -e "\n\ndocker build -t $respoistory/$1:$tag ."
	docker build -t $respoistory/$1:$tag .
	cd ..
}


echo -e "\ndocker rm -f slave1 slave2 master"
docker rm -f slave1 slave2 master

docker images > images.txt

if [ $image == "serf-dnsmasq" ]
then
	docker_rmi hadoop-master
	docker_rmi hadoop-slave
	docker_rmi hadoop-base
	docker_rmi serf-dnsmasq
	docker_build serf-dnsmasq
	docker_build hadoop-base
	docker_build hadoop-master
	docker_build hadoop-slave 
elif [ $image == "hadoop-base" ]
then
	docker_rmi hadoop-master
	docker_rmi hadoop-slave
	docker_rmi hadoop-base
	docker_build hadoop-base
	docker_build hadoop-master
	docker_build hadoop-slave
elif [ $image == "hadoop-master" ]
then
	docker_rmi hadoop-master
	docker_build hadoop-master
elif [ $image == "hadoop-slave" ]
then
	docker_rmi hadoop-slave
	docker_build hadoop-slave
else
	echo "The image name is wrong!"
fi

echo -e "\nimages before build"
cat images.txt
rm images.txt

echo -e "\nimages after build"
docker images
