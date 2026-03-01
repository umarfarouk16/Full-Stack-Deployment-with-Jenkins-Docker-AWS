pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECS_CLUSTER = 'techpathway-cluster'
        BACKEND_SERVICE = 'techpathway-backend-service'
        FRONTEND_SERVICE = 'techpathway-frontend-service'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup AWS CLI') {
            steps {
                sh '''
                    if ! command -v aws >/dev/null 2>&1; then
                        echo "AWS CLI not found, installing v2..."
                        curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
                        unzip -q /tmp/awscliv2.zip -d /tmp/
                        /tmp/aws/install
                    fi
                    aws --version
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh '''
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

                    echo "Deployment commands executed successfully."
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
            echo 'Frontend URL: http://techpathway-frontend-alb-1807582629.us-east-1.elb.amazonaws.com'
        }
        failure {
            echo 'Pipeline failed. Check logs above.'
        }
    }
}
