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

        stage('Deploy to ECS') {
            steps {
                sh '''
                    # Install AWS CLI v2 to /tmp if not already available
                    if ! command -v aws >/dev/null 2>&1 && [ ! -f /tmp/aws-bin/aws ]; then
                        echo "Installing AWS CLI v2..."
                        curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
                        unzip -q /tmp/awscliv2.zip -d /tmp/
                        /tmp/aws/install --install-dir /tmp/aws-cli --bin-dir /tmp/aws-bin
                    fi

                    export PATH=$PATH:/tmp/aws-bin
                    aws --version

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
            echo 'Frontend URL: http://techpathway-frontend-alb-149258769.us-east-1.elb.amazonaws.com'
        }
        failure {
            echo 'Pipeline failed. Check logs above.'
        }
    }
}
