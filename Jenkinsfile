pipeline {
    agent any
    
    tools {
        terraform 'terraform-v1'
    }

     parameters {
        booleanParam(name: 'SKIP_TF_APPLY', defaultValue: false, description: 'Skip terraform apply')
        booleanParam(name: 'SKIP_TF_DESTROY', defaultValue: false, description: 'Skip terraform destroy')
    }
    
    stages {

        stage('Terraform Initialize') {

            steps {
               sh 'terraform init'
            }
        }
        
        stage('Terraform apply') {

            when {
                expression { !params.SKIP_TF_APPLY }
            }

            steps {
               sh 'terraform apply -auto-approve'
            }
        }


        stage('Terraform destroy') {

            when {
                expression { !params.SKIP_TF_DESTROY }
            }
            
            steps {
               sh 'terraform destroy -auto-approve'
            }
        }
    }
}
