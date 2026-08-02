def configuration = [
                        vaultUrl: "http://${env.VAULT_IP}:${env.VAULT_PORT}",
                        vaultCredentialId: 'vault-approle',
                        engineVersion: 2
                    ]

pipeline {
    agent any

    parameters {
        string(name: 'APP_VERSION', defaultValue: '1.0', description: 'App version')
        string(name: 'APP_PLATFORM', defaultValue: 'linux/amd64', description: 'App platform')
        string(name: 'APP_DIR_NAME', defaultValue: 'shareit', description: 'Application data directory name')
    }

    environment {
        SERVER_IMAGE = "cr.yandex/${env.YCR_ID}/shareit-server:${params.APP_VERSION}"
        GATEWAY_IMAGE = "cr.yandex/${env.YCR_ID}/shareit-gateway:${params.APP_VERSION}"
        APP_DIR_PATH = "${env.APP_DIR_BASE_PATH}/${params.APP_DIR_NAME}"
    }

    stages {
        stage("Build and push Image") {
            steps {
                withVault(
                    configuration: configuration,
                    vaultSecrets: [
                    [
                        path: 'secret/jenkins/ycr',
                        engineVersion: 2,
                        secretValues: [
                            [envVar: 'YCR_KEY', vaultKey: 'container-registry-sa-key']
                        ]
                    ]
                    ]) {
                        sh 'printenv YCR_KEY | docker login --username json_key --password-stdin cr.yandex'
                        sh "docker buildx build --target gateway -t ${env.GATEWAY_IMAGE} ."
                        sh "docker buildx build --target server -t ${env.SERVER_IMAGE} ."
                        sh "docker push --platform ${params.APP_PLATFORM} ${env.GATEWAY_IMAGE}"
                        sh "docker push --platform ${params.APP_PLATFORM} ${env.SERVER_IMAGE}"
                    }
            }
        }

        stage("Deploy Application") {
            steps {
                withVault(
                    configuration: configuration,
                    vaultSecrets: [
                        [
                            path: 'secret/jenkins/ssh',
                            engineVersion: 2,
                            secretValues: [
                                [envVar: 'SSH_USERNAME', vaultKey: 'app-node-ssh-username']
                            ]
                        ],
                        [
                            path: 'secret/jenkins/db',
                            engineVersion: 2,
                            secretValues: [
                                [envVar: 'DB_USER', vaultKey: 'username'],
                                [envVar: 'DB_PASSWORD', vaultKey: 'password'],
                            ]
                        ],
                        [
                            path: 'secret/jenkins/ycr',
                            engineVersion: 2,
                            secretValues: [
                                [envVar: 'YCR_KEY', vaultKey: 'container-registry-sa-key']
                            ]
                        ]
                    ]) {
                        sshagent(credentials: ['app-node-ssh']) {
                            sh "ssh -o StrictHostKeyChecking=no ${env.SSH_USERNAME}@${env.APP_SERVER_IP} 'mkdir -p ${env.APP_DIR_PATH}'"
                            sh "scp -o StrictHostKeyChecking=no ./docker-compose.yaml ${env.SSH_USERNAME}@${env.APP_SERVER_IP}:${env.APP_DIR_PATH}"
                            sh "printenv YCR_KEY | ssh -o StrictHostKeyChecking=no ${env.SSH_USERNAME}@${env.APP_SERVER_IP} 'docker login --username json_key --password-stdin cr.yandex'"

                            sh """
                                ssh -o StrictHostKeyChecking=no ${env.SSH_USERNAME}@${env.APP_SERVER_IP} '
                                    export DB_USER="${DB_USER}"
                                    export DB_PASSWORD="${DB_PASSWORD}"
                                    export SERVER_IMAGE=${env.SERVER_IMAGE}
                                    export GATEWAY_IMAGE=${env.GATEWAY_IMAGE}

                                    cd ${env.APP_DIR_PATH}

                                    docker compose pull

                                    docker compose down --rmi all || true
                                    docker compose up -d

                                    docker logout cr.yandex
                                '
                            """
                        }
                    }
            }
        }
    }

    post {
        always {
            sh 'docker image prune -af'
            sh 'rm -rf ./*'
        }
    }
}
