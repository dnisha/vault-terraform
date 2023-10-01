pipeline {
    agent any

    tools {
        terraform 'terraform-v1'
    }

    parameters {
        booleanParam(name: 'TF_APPLY', defaultValue: false, description: 'terraform apply')
        booleanParam(name: 'TF_DESTROY', defaultValue: false, description: 'terraform destroy')
    }
    
    stages {
        
        stage('Terraform Initialize') {

            steps {
               sh 'terraform init'
            }
        }
        
        stage('Terraform apply') {

            when {
                expression { params.TF_APPLY }
            }

            steps {
               sh 'terraform apply -auto-approve'
            }
        }

        stage('Get BastianIp') {

            when {
                expression { params.TF_APPLY }
            }

            steps {

                sh 'rm -rf infra-output.txt'
                sh 'terraform output > infra-output.txt'

                script {
                    env.BASTION_IP = sh(script: 'awk -F "\"" "/batian_instance_ip/ { print $2 }" infra-output.txt', returnStdout: true).trim()
                }

            }
        }

        stage('Use Bastion IP') {

            when {
                expression { params.TF_APPLY }
            }
            
            steps {
                script {
                    def bastionIp = env.BASTION_IP

                    echo "Using Bastion IP in another stage: $bastionIp"
                }
            }
        }

        stage('Terraform destroy') {

            when {
                expression { params.TF_DESTROY }
            }
            
            steps {
               sh 'terraform destroy -auto-approve'
            }
        }
    }
}
