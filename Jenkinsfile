pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECS_CLUSTER = 'techpathway-cluster'
        BACKEND_SERVICE = 'techpathway-backend-service'
        FRONTEND_SERVICE = 'techpathway-frontend-service'
        AWS_CLI = '/usr/bin/aws' // full path to AWS CLI on EC2
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
                    echo '🚀 Deploying to ECS...'
                    sh '''
                        # Ensure AWS CLI is available
                        if [ ! -x "$AWS_CLI" ]; then
                            echo "❌ AWS CLI not found at $AWS_CLI"
                            exit 1
                        fi

                        echo "✅ AWS CLI found at $AWS_CLI"

                        # Deploy backend service
                        $AWS_CLI ecs update-service \
                            --cluster ${ECS_CLUSTER} \
                            --service ${BACKEND_SERVICE} \
                            --force-new-deployment \
                            --region ${AWS_REGION}

                        # Deploy frontend service
                        $AWS_CLI ecs update-service \
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