pipeline {
    agent any

    environment {
        AWS_REGION      = 'us-east-1'
        AWS_ACCOUNT_ID  = '003021232742'
        ECR_BACKEND     = "003021232742.dkr.ecr.us-east-1.amazonaws.com/techpathway-backend"
        ECR_FRONTEND    = "003021232742.dkr.ecr.us-east-1.amazonaws.com/techpathway-frontend"
        ECS_CLUSTER     = 'techpathway-cluster'
        BACKEND_SERVICE = 'techpathway-backend-service'
        FRONTEND_SERVICE= 'techpathway-frontend-service'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push to ECR') {
            options {
                timeout(time: 60, unit: 'MINUTES')
            }
            steps {
                sh '''
                    # Install AWS CLI v2 to /tmp if not already present
                    if ! command -v aws >/dev/null 2>&1 && [ ! -f /tmp/aws-bin/aws ]; then
                        echo "Installing AWS CLI v2..."
                        curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
                        unzip -q /tmp/awscliv2.zip -d /tmp/
                        /tmp/aws/install --install-dir /tmp/aws-cli --bin-dir /tmp/aws-bin
                    fi
                    export PATH=$PATH:/tmp/aws-bin

                    # Log in to ECR
                    aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

                    # Build and push backend
                    docker build -t ${ECR_BACKEND}:latest ./techpathway-2/backend
                    docker push ${ECR_BACKEND}:latest

                    # Build and push frontend
                    docker build -f ./techpathway-2/frontend/src/Dockerfile -t ${ECR_FRONTEND}:latest ./techpathway-2/frontend
                    docker push ${ECR_FRONTEND}:latest
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh '''
                    export PATH=$PATH:/tmp/aws-bin

                    # Deploy backend service
                    aws ecs update-service \
                        --cluster ${ECS_CLUSTER} \
                        --service ${BACKEND_SERVICE} \
                        --force-new-deployment \
                        --region ${AWS_REGION}

                    # Deploy frontend service
                    aws ecs update-service \
                        --cluster ${ECS_CLUSTER} \
                        --service ${FRONTEND_SERVICE} \
                        --force-new-deployment \
                        --region ${AWS_REGION}

                    echo "Deployment triggered successfully."
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
            echo 'Frontend URL: http://techpathway-frontend-alb-149258769.us-east-1.elb.amazonaws.com'
        }
        failure {
            echo 'Pipeline failed. Check logs above.'
        }
    }
}
