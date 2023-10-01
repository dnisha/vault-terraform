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
