pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        ECS_CLUSTER = 'techpathway-cluster'
        BACKEND_SERVICE = 'techpathway-backend-service'
        FRONTEND_SERVICE = 'techpathway-frontend-service'
        AWS_CLI = '/usr/bin/aws' // full path
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Deploy to ECS') {
            steps {
                script {
                    sh '''
                        $AWS_CLI ecs update-service \
                            --cluster ${ECS_CLUSTER} \
                            --service ${BACKEND_SERVICE} \
                            --force-new-deployment \
                            --region ${AWS_REGION}
                        
                        $AWS_CLI ecs update-service \
                            --cluster ${ECS_CLUSTER} \
                            --service ${FRONTEND_SERVICE} \
                            --force-new-deployment \
                            --region ${AWS_REGION}
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo "✅ Pipeline completed successfully!"
            echo "Frontend URL: http://techpathway-frontend-alb-1807582629.us-east-1.elb.amazonaws.com"
        }
        failure {
            echo "❌ Pipeline failed. Check logs above."
        }
    }
}