pipeline {
    agent {
        label('terraform')
    }
    environment {
        PYPI_CREDENTIALS = credentials("pypi-credentials")
    }
    
    stages {
        stage('Build') {
            steps {
                dir('python-app-example') {
                    sh 'pip install -r requirements.txt'
                }
            }
        }
        stage('Unit Test') {
            steps {
                dir('python-app-example') {
                    sh 'python -m coverage run -m pytest -s -v'
                }
            }
        }
        stage('Coverage') {
            steps {
                dir('python-app-example') {
                    sh 'python -m coverage report -m --fail-under=90'
                }
            }
        }
        stage('Package'){
            steps {
                dir('python-app-example') {
                    sh 'python -m build'
                }
            }
        }
         stage('Publish'){
            steps {
                dir('python-app-example') {
                    timeout(time: 10, unit: 'MINUTES'){
                        input message: 'Are you sure to deploy?', ok: 'Yes, deploy to pypi'
                            sh 'python -m twine upload dist/* -u $PYPI_CREDENTIALS_USR -p $PYPI_CREDENTIALS_PSW --skip-existing'
                        
                    }
                }
            }
        }
    }
}