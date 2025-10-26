pipeline {
  agent any

  environment {
    DOCKER_USER = "alexalphonse"
    DOCKERHUB_CREDENTIALS_ID = "docker-hub-creds"
    DEV_REPO = "${DOCKER_USER}/devops-build-dev"
    PROD_REPO = "${DOCKER_USER}/devops-build-prod"
    
    DEVOPS_IP = "ec2-43-204-130-117.ap-south-1.compute.amazonaws.com"
    DEVOPS_SSH_CREDS = "ec2-ssh-key"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        echo "Source code checked out successfully."
        script {
          env.BRANCH_NAME = env.BRANCH_NAME ?: sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()
          echo "Current branch: ${env.BRANCH_NAME}"
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $DEV_REPO:latest .'
      }
    }

    stage('Tag for Prod') {
      steps {
        script {
          echo "Tagging DEV image for PROD repo..."
          sh 'docker tag $DEV_REPO:latest $PROD_REPO:latest'
        }
      }
    }

    stage('Push & Deploy Prod') {
      steps {
        script {
          echo "Running Push & Deploy Prod on branch: ${env.BRANCH_NAME}"
          
          // 1. PUSH TO DOCKERHUB PROD REPO
          echo "1. Pushing to DockerHub PROD repo..."
          withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", usernameVariable: 'DBUSER', passwordVariable: 'DBPASS')]) {
            sh '''
              echo "$DBPASS" | docker login -u "$DBUSER" --password-stdin
              docker push $PROD_REPO:latest
              docker logout
            '''
          }
          
          // 2. DEPLOY PROD IMAGE VIA SSH
          echo "2. Deploying PROD image to DevOps EC2 at $DEVOPS_IP..."
          sshagent(credentials: ["${DEVOPS_SSH_CREDS}"]) { 
            sh """
              ssh -o StrictHostKeyChecking=no ubuntu@$DEVOPS_IP '
                docker pull ${PROD_REPO}:latest
                docker stop react-app-prod 2>/dev/null || true
                docker rm react-app-prod 2>/dev/null || true
                docker run -d -p 3000:80 --name react-app-prod ${PROD_REPO}:latest
                echo "Prod container status:"
                docker ps --filter "name=react-app-prod"
              '
            """
          }
        }
      }
    }
  }

  post {
    success { echo "✅ Prod pipeline completed successfully!" }
    failure { echo "❌ Prod pipeline failed — check build logs for errors." }
  }
}
