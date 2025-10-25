#!/bin/bash

# Variables
DOCKER_USER="alexalphonse"
IMAGE_NAME="react-app"

# Build the image
docker build -t $DOCKER_USER/devops-build-prod:latest .

# Push to DockerHub dev repo
docker push $DOCKER_USER/devops-build-prod:latest
