pipeline {
    agent {
        label('terraform')
    }
    environment {
        PYPI_CREDENTIALS = credentials("pypi-credentials")
    }

    stages {
        stage('Init-dev') {
            steps {
                dir('infraestructura') {
                    sh 'pip install -r requirements.txt'
                }
            }
        }
        stage('Plan-dev') {
            steps {
                dir('infraestructura') {
                    sh 'python -m coverage run -m pytest -s -v'
                }
            }
        }
        stage('Apply-dev') {
            steps {
                dir('infraestructura') {
                    sh 'python -m coverage report -m --fail-under=90'
                }
            }
        }
        stage('Init-prod'){
            steps {
                dir('infraestructura') {
                    sh 'python -m build'
                }
            }
        }
        stage('Plan-prod'){
            steps {
                dir('infraestructura') {
                    sh 'python -m build'
                }
            }
        }
         stage('Apply-prod'){
            steps {
                dir('infraestructura') {
                    timeout(time: 10, unit: 'MINUTES'){
                        input message: 'Are you sure to deploy?', ok: 'Yes, deploy to pypi'
                            sh 'python -m twine upload dist/* -u $PYPI_CREDENTIALS_USR -p $PYPI_CREDENTIALS_PSW --skip-existing'
                        
                    }
                }
            }
        }
    }
}