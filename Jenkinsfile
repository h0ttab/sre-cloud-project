pipeline {
    agent any
    
    parameters {
        string(name: 'APP_SERVER_IP', defaultValue:'10.10.1.18', description: 'Target server IP')
    }

    environment {
        APP_NAME = 'test-web-app'
        APP_VERSION = '1.30.4-alpine'
    }

    stages {
        stage("Deploy to app server") {
            options {
                timeout(time: 5, unit: 'MINUTES')
            }
            steps {
                sshagent(credentials: ['app-node-ssh-key']){
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@$APP_SERVER_IP 'docker stop $APP_NAME || true; docker rm $APP_NAME || true; docker run -d --name $APP_NAME -p 80:80 nginx:$APP_VERSION'
                    """
                }
            }
        }
    }
}