pipeline {
    agent {
        label('terraform')
    }
    environment {
        AWS_CREDENTIALS = credentials("aws-credentials")
        AWS_ACCESS_KEY_ID = "${env.AWS_CREDENTIALS_USR}"
        AWS_SECRET_KEY = "${env.AWS_CREDENTIALS_PSW}"
    }

    stages {
        stage('Init-dev') {
            steps {
                dir('infraestructura') {
                    sh 'terraform init -backend-config="key=dev/terraform.practica-final-cicd"'
                }
            }
        }
        stage('Plan-dev') {
            steps {
                dir('infraestructura') {
                    sh 'terraform plan -var="environment=dev"'
                }
            }
        }
        stage('Apply-dev') {
            steps {
                dir('infraestructura') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Clean') {
            steps {
                dir('infraestructura') {
                    sh 'rm -rf .terraform'
                }
            }
        }
        stage('Init-prod'){
            steps {
                dir('infraestructura') {
                    sh 'terraform init -backend-config="key=prod/terraform.practica-final-cicd"'
                }
            }
        }
        stage('Plan-prod'){
            steps {
                dir('infraestructura') {
                    sh 'terraform plan -var="environment=prod"'
                }
            }
        }
         stage('Apply-prod'){
            steps {
                dir('infraestructura') {
                    timeout(time: 10, unit: 'MINUTES'){
                        input message: 'Are you sure to deploy?', ok: 'Yes, deploy to prod'
                            sh 'terraform apply -auto-approve'
                        
                    }
                }
            }
        }
    }
}