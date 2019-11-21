// Define Global variables
def worker_nodes = "${params.Worker_Nodes}"
def Region = "${params.Region}"
def Owner = "${params.Owner}"
def Environment = "${params.Environment}"
def Business_Vertical ="${params.Business_Vertical}"
def Team = "${params.Team}"
def App = "${params.App}"
def instance_type ="${params.instance_type}"
def key_pair = "${params.key_pair}"
def ami_name = "${params.ami_name}"
def subnet = "${param.subnet}"
def root_vol_size = "${params.root_vol_size}"
def root_vol_delete_on_termination = "${params.root_vol_delete_on_termination}"





node('master') {
  stage('Checkout')  {
    git branch: 'master', changelog: true, credentialsId: 'github-sanu-private-key', url: 'git@github.com:sanusatyadarshi/terraform-personal.git'
    skipBuild = sh (script: "git log -1 --pretty=format:%s#%b | grep '\\[skip ci\\]'", returnStatus: true) == 0
  }

  stage('Use user-input') {
    dir("terraform/modules/ec2") {
      sh """ sed -i 's/default_instance_type/${instance_type}/g' vars.tf
      sed -i 's/default_worker_nodes/${worker_nodes}/g' vars.tf
      sed -i 's/default_Region/${Region}/g' vars.tf
      sed -i 's/default_Owner/${Owner}/g' vars.tf
      sed -i 's/default_Environment/${Environment}/g' vars.tf
      sed -i 's/default_Business_Vertical/${Business_Vertical}/g' vars.tf
      sed -i 's/default_Team/${Team}/g' vars.tf
      sed -i 's/default_key_pair/${key_pair}/g' vars.tf
      sed -i 's/default_ami_name/${ami_name}/g' vars.tf
      sed -i 's/default_subnet/${subnet}/g' vars.tf
      sed -i 's/default_root_vol_size/${root_vol_size}/g' vars.tf
      sed -i 's/default_root_vol_delete_on_termination/${root_vol_delete_on_termination}/g' vars.tf
      """
    }
  }

  stage('Terraform Plan') { 
    dir("terraform/modules/ec2") {
      sh 'terraform init [ -f terraform.tfstate ] && rm terraform.tfstate ' 
      sh 'terraform plan –out=tfplan.txt '
    }
  }

  // I may have to convert this stage to scripted pipeline  
  stage('Approval') { 
    steps { 
      script { 
        def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ]) 
      } 
    } 
  }

  stage('Terraform Apply') { 
    dir(terraform/modules/ec2) {
      sh ' terraform apply -auto-approve tfplan.txt ' 
      //sh ‘echo "`terraform output`" | mail -s "${Env^} EC2 created by ${BUILD_USER} for ${Team} Team in ${region} region" -r email@company-domain.com email@company-domain.com’
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

}





 



    





