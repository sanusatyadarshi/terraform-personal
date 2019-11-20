stage('Checkout') { 
      steps { 
        checkout scm 
        sh ' cd devops/terraform/modules/ec2/' 
        sh """ sed -i '/instance_type=.*/c instance_type='\""${instance_type}"\"'' terraform.tfvars 
sed -i '/key_pair=.*/c key_pair='\""${key_pair}"\"'' terraform.tfvars 
sed -i '/ami_name=.*/c ami_name='\""${ami_name}"\"'' terraform.tfvars 
sed -i '/subnet=.*/c subnet='\""${subnet}"\"'' terraform.tfvars 
sed -i '/root_vol_size=.*/c root_vol_size='\""${root_vol_size}"\"'' terraform.tfvars 
sed -i '/root_vol_delete_on_termination=.*/c root_vol_delete_on_termination='\""${root_vol_delete_on_termination}"\"'' terraform.tfvars 
        """ 
      } }
 
stage('Plan') { 
       steps { 
           sh 'terraform init [ -f terraform.tfstate ] && rm terraform.tfstate ' 
           sh 'terraform plan –out=tfplan.txt ' 
       } 
     }
     
stage('Approval') { 
      steps { 
        script { 
          def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ]) 
        } 
      } 
    }
    
stage('Apply') { 
      steps { 
          sh ‘terraform apply -auto-approve tfplan.txt ' 
sh ‘echo "`terraform output`" | mail -s "${Env^} EC2 created by ${BUILD_USER} for ${Team} Team in ${region} region" -r email@company-domain.com email@company-domain.com’ 

        } 
      }
