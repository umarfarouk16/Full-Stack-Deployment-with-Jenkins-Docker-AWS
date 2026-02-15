pipeline {
  agent any

  environment {
    AWS_REGION = "us-east-1"
    ECR_FRONTEND = "913524913001.dkr.ecr.us-east-1.amazonaws.com/techpathway-frontend"
    ECR_BACKEND  = "913524913001.dkr.ecr.us-east-1.amazonaws.com/techpathway-backend"
    ECS_CLUSTER = "techpathway-cluster"
    FRONTEND_SERVICE = "techpathway-frontend-service"
    BACKEND_SERVICE  = "techpathway-backend-service"
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/umarfarouk16/Full-Stack-Deployment-with-Jenkins-Docker-AWS.git'
      }
    }

    stage('Build Docker Images') {
      steps {
        sh '''
        docker build -t techpathway-frontend techpathway-2/frontend
        docker build -t techpathway-backend techpathway-2/backend
        '''
      }
    }

    stage('Login to ECR') {
      steps {
        sh '''
        aws ecr get-login-password --region $AWS_REGION \
        | docker login --username AWS --password-stdin $ECR_FRONTEND
        aws ecr get-login-password --region $AWS_REGION \
        | docker login --username AWS --password-stdin $ECR_BACKEND
        '''
      }
    }

    stage('Push Docker Images') {
      steps {
        sh '''
        docker tag techpathway-frontend:latest $ECR_FRONTEND:latest
        docker tag techpathway-backend:latest $ECR_BACKEND:latest
        docker push $ECR_FRONTEND:latest
        docker push $ECR_BACKEND:latest
        '''
      }
    }

    stage('Deploy to ECS') {
      steps {
        sh '''
        aws ecs update-service --cluster $ECS_CLUSTER \
        --service $FRONTEND_SERVICE --force-new-deployment

        aws ecs update-service --cluster $ECS_CLUSTER \
        --service $BACKEND_SERVICE --force-new-deployment
        '''
      }
    }

    stage('Show URLs') {
      steps {
        echo "Frontend URL: http://techpathway-frontend-alb-1807582629.us-east-1.elb.amazonaws.com"
        echo "Backend URL: http://techpathway-backend-alb-454838952.us-east-1.elb.amazonaws.com"
      }
    }
  }
}
