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
                echo '📦 Checking out code from GitHub...'
                checkout scm
            }
        }

        stage('Deploy to ECS') {
            steps {
                script {
                    sh '''
                        # Add AWS CLI to PATH for Jenkins
                        export PATH=$PATH:/usr/bin

                        # Ensure AWS CLI is available
                        if ! command -v aws &> /dev/null; then
                            echo "❌ AWS CLI not found in PATH"
                            exit 1
                        fi
                        echo "✅ AWS CLI found in PATH"

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

                        echo "🚀 Deployment commands executed successfully."
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
            echo 'Frontend URL: http://techpathway-frontend-alb-1807582629.us-east-1.elb.amazonaws.com'
        }
        failure {
            echo '❌ Pipeline failed. Check logs above.'
        }
    }
}