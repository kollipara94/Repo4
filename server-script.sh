#! /bin/bash

#sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
#sudo yum install maven -y
sudo yum install docker -y
sudo systemctl start docker

if [ -d "Repo4" ]
then
   echo "repo is already cloned and exists"
   cd /home/ec2-user/Repo4
   git pull origin feb-docker
else
   git clone https://github.com/kollipara94/Repo4.git
   git checkout feb-docker
fi

#mvn package
docker build -t myimage /home/ec2-user/Repo4
