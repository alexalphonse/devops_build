pipeline {
  agent any

  environment {
    DOCKER_USER = "alexalphonse"
    DOCKERHUB_CREDENTIALS_ID = "docker-hub-creds"
    DEV_REPO = "${DOCKER_USER}/devops-build-dev"
    
    DEVOPS_IP = "43.204.130.117"
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

    stage('Push & Deploy Dev') {
      steps {
        script {
          echo "Running Push & Deploy Dev on branch: ${env.BRANCH_NAME}"
          
          // 1. PUSH TO DOCKERHUB DEV REPO
          echo "1. Pushing to DockerHub DEV repo..."
          withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", usernameVariable: 'DBUSER', passwordVariable: 'DBPASS')]) {
            sh '''
              echo "$DBPASS" | docker login -u "$DBUSER" --password-stdin
              docker push $DEV_REPO:latest
              docker logout
            '''
          }
          
          // 2. DEPLOY DEV IMAGE VIA SSH
          echo "2. Deploying DEV image to DevOps EC2 at $DEVOPS_IP..."
          sshagent(credentials: ["${DEVOPS_SSH_CREDS}"]) { 
            sh """
              ssh -o StrictHostKeyChecking=no ubuntu@$DEVOPS_IP '
                docker pull ${DEV_REPO}:latest
                docker stop react-app 2>/dev/null || true
                docker rm react-app 2>/dev/null || true
                docker run -d -p 80:80 --name react-app ${DEV_REPO}:latest
                echo "Container status:"
                docker ps --filter "name=react-app"
              '
            """
          }
        }
      }
    }
  }

  post {
    success { echo "✅ Dev pipeline completed successfully!" }
    failure { echo "❌ Dev pipeline failed — check build logs for errors." }
  }
}
