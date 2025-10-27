# Deploying a React application toa production ready state

## Step 01

### clone the repo

```
git clone https://github.com/sriram-R-krishnan/devops-build

```
## Step 02

### Dockerize the application

<img src="images/dockerfile_dev.png" width="500" align="center">

## Step 03

### Create a docker compose file using the above image

<img src="images/docker-compose_dev.png" width="500" align="center">

## Step 04

### Write a bash script for building the docker image

<img src="images/build.sh_dev.png" width="500" align="center">

## Step 05

### Write a bash script for deploying the docker image

<img src="images/deploy.sh_dev.png" width="500" align="center">

## Step 06

### push the code to github with .dockerignore and .gitinore files

```
git add .

git commit -am "initail commit"

git push origin dev

```

## Step 07

### create two repository in dockerhub "dev" and "prod" to push images

### "prod" repo must be private and dev can be public

<img src="images/dockerhub_repo.png" width="500" align="center">

## Step 08

### Install jenkins

<img src="images/jenkins_login.png" width="500" align="center">


## Step 09

### connect jenkins and github

<img src="images/jenkins_github.png" width="500" align="center">

## Step 10

### automate pushed code to dev branch to buld docker image and push to dev repo in dockerhub

<img src="images/jenkins_build_dev.png" width="500" align="center">
<img src="images/jenkins_push_dev.png" width="500" align="center">

## Step 11

### automate pushed code to prod branch to buld docker image and push to prod repo in dockerhub

<img src="images/jenkins_build_prod.png" width="500" align="center">
<img src="images/jenkins_push_prod.png" width="500" align="center">

## Step 12

### launch a ec2 instance to deploy the application
<img src="images/ec2_instance.png" width="500" align="center">

## Step 13

### configure sg group in such a way that everyone can access the application but only i can acces the server
<img src="images/sg_group.png" width="500" align="center">

## Step 14

### setup a monitoring stack to monitor the health status
<img src="images/grafana.png" width="500" align="center">

## Step 15

### application output
<img src="images/application_output.png" width="500" align="center">

