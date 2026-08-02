pipeline {
    agent any

    parameters {
        string(name: 'APP_SERVER_IP', defaultValue:'10.10.1.18', description: 'Target server IP')
        string(name: 'YCR_ID', defaultValue: 'crpe2to495vf01mivd2e', description: 'Yandex Container Registry ID')
        string(name: 'APP_NAME', defaultValue: 'filmorate', description: 'App name')
        string(name: 'APP_VERSION', defaultValue: '1.0', description: 'App version')
        string(name: 'APP_PLATFORM', defaultValue: 'linux/amd64', description: 'App platform')
        string(name: 'VAULT_IP', defaultValue: '10.10.1.26', description: 'Vault IP')
        string(name: 'VAULT_PORT', defaultValue: '8200', description: 'Vault port')
    }

    stages {
        stage("Build Image") {
            steps {
                sh "docker buildx build --platform ${params.APP_PLATFORM} -t cr.yandex/${params.YCR_ID}/${params.APP_NAME}:${params.APP_VERSION} ."
            }
        }

        stage("Push Image") {
            steps {
                script {
                    def secrets = [
                        [
                            path: 'secret/jenkins/ycr',
                            engineVersion: 2,
                            secretValues: [
                                [envVar: 'YCR_KEY', vaultKey: 'key.json']
                            ]
                        ]
                    ]

                    def configuration = [
                        vaultUrl: "http://${params.VAULT_IP}:${params.VAULT_PORT}",
                        vaultCredentialId: 'vault-approle',
                        engineVersion: 2
                    ]

                    withVault(configuration: configuration, vaultSecrets: secrets) {
                        sh 'printenv YCR_KEY | docker login --username json_key --password-stdin cr.yandex'
                        sh "docker push --platform ${params.APP_PLATFORM} cr.yandex/${params.YCR_ID}/${params.APP_NAME}:${params.APP_VERSION}"
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
