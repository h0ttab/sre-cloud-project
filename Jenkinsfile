pipeline {
    agent any
    
    parameters {
        string(name: 'APP_SERVER_IP', defaultValue:'10.10.1.18', description: 'Target server IP')
    }

    environment {
        APP_NAME = 'test-web-app'
    }

    stages {
        stage("Deploy to app server") {
            steps {
                sshagent(credentials: ['app-node-ssh-key']){
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@$APP_SERVER_IP 'docker stop $APP_NAME || true; docker rm $APP_NAME || true; docker run -d --name $APP_NAME -p 80:80 nginx:alpine'
                    """
                }
            }
        }
    }
}