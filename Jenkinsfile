stage('Checkout') { 
  steps { 
    checkout scm 
    sh ' cd terraform/modules/ec2/' 
    sh """ sed -i '/instance_type=.*/c instance_type='\""${instance_type}"\"'' vars.tf 
    sed -i '/key_pair=.*/c key_pair='\""${key_pair}"\"'' vars.tf 
    sed -i '/ami_name=.*/c ami_name='\""${ami_name}"\"'' vars.tf 
    sed -i '/subnet=.*/c subnet='\""${subnet}"\"'' vars.tf 
    sed -i '/root_vol_size=.*/c root_vol_size='\""${root_vol_size}"\"'' vars.tf 
    sed -i '/root_vol_delete_on_termination=.*/c root_vol_delete_on_termination='\""${root_vol_delete_on_termination}"\"'' vars.tf 
    """ 
  }
}
 
stage('Terraform Plan') { 
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
    
stage('Terraform Apply') { 
  steps { 
      sh ' terraform apply -auto-approve tfplan.txt ' 
      sh ‘echo "`terraform output`" | mail -s "${Env^} EC2 created by ${BUILD_USER} for ${Team} Team in ${region} region" -r email@company-domain.com email@company-domain.com’
      }  
  }

stage('Input from Terraform Resources') {
  dir("k8s-ansible") {
    sh 'cp ../terraform/modules/ec2/ip_address.txt ip_address.txt '
    // NOW I want to take the ip addresses of ec2 instances created by terraform from ip_address.txt
    // and replace the placeholders MASTER_NODE_IP_ADDRESS, WORKER1_NODE_IP_ADDRESS, WORKER2_NODE_IP_ADDRESS in the hosts file
    // with the ip addresses from the ip_address.txt file.  I need to do sed in order for this to work
    
    
  }
}

stage('Create K8s Cluster') {
  dir("k8s-ansible") {
      sh 'ansible-playbook -i hosts ~/kube-ansible/non-root-user.yml'
      sh 'ansible-playbook -i hosts ~/kube-ansible/kube-dependencies.yml'
      sh 'ansible-playbook -i hosts ~/kube-ansible/master-cluster.yml'
      sh 'ansible-playbook -i hosts ~/kube-ansible/workers-cluster.yml'
  }
}
