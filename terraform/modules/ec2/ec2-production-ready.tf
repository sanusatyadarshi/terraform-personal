resource "aws_instance" "Master-Node" {
  ami                         = "${data.aws_ami.ami.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_pair}"
  vpc_security_group_ids      = ["${aws_security_group.ec2-sg.id}"]
  subnet_id                   = "${element(random_shuffle.subnet.result,0)}"
  user_data                   = "${data.template_file.user_data.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.ec2-profile.id}"
  user_data                   = "${data.template_file.user_data.rendered}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  count                       = "1"
  root_block_device {
    volume_type           = "${var.root_vol_type}"
    volume_size           = "${var.root_vol_size}"
    delete_on_termination = "${var.root_vol_delete_on_termination}"
  }
  tags = {
    Name      = "Master Node"
    Team      = "${var.Team}"
    Environment       = "${var.Environment}"
    Service   = "${var.Service}"
    App       = "${var.App}"
    Terraform = true
    Business_Vertical = "${var.Business_Vertical}"
    Owner = "${var.Owner}"
    Monitor   = "yes"
    Monitor_APP = "${var.Monitor_APP}"
    Project = "${var.Team}-${var.App}-${var.Service}-${var.Environment}"
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt -y update"
    ]
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} >> ip_address.txt"
  }
}
}

resource "aws_instance" "Worker-Node" {
  ami                         = "${data.aws_ami.ami.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_pair}"
  vpc_security_group_ids      = ["${aws_security_group.ec2-sg.id}"]
  subnet_id                   = "${element(random_shuffle.subnet.result,0)}"
  user_data                   = "${data.template_file.user_data.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.ec2-profile.id}"
  user_data                   = "${data.template_file.user_data.rendered}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  count                       = "${var.count}"
  root_block_device {
    volume_type           = "${var.root_vol_type}"
    volume_size           = "${var.root_vol_size}"
    delete_on_termination = "${var.root_vol_delete_on_termination}"
  }
  tags = {
    Name      = "Worker Node"
    Team      = "${var.Team}"
    Environment       = "${var.Environment}"
    Service   = "${var.Service}"
    App       = "${var.App}"
    Terraform = true
    Business_Vertical = "${var.Business_Vertical}"
    Owner = "${var.Owner}"
    Monitor   = "yes"
    Monitor_APP = "${var.Monitor_APP}"
    Project = "${var.Team}-${var.App}-${var.Service}-${var.Environment}"
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt -y update"
    ]
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} >> ip_address.txt"
  }
}

// This part of the code will be removed later

# provider "aws" {
#   access_key = "${var.AWS_ACCESS_KEY}"
#   secret_key = "${var.AWS_SECRET_KEY}"
#   region     = "${var.AWS_REGION}"
# }

# resource "aws_key_pair" "example" {
#   key_name = "examplekey"
#   public_key = file("~/.ssh/id_rsa.pub")
#  }

# resource "aws_eip" "ip" {
#     vpc = true
#     instance = aws_instance.example.id
# }

# resource "aws_instance" "example" {
#   ami           = "ami-04b9e92b5572fa0d1"
#   instance_type = "t2.micro"
#   key_name      = aws_key_pair.example.key_name
#   depends_on    = [aws_key_pair.example]
#   tags = {
#     Name = "terraform-test"
#  }
#   connection {
#     type     = "ssh"
#     user     = "ubuntu"
#     private_key = file("~/.ssh/id_rsa")
#     host     = self.public_ip
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt -y update",
#       "sudo apt -y install nginx",
#       "sudo systemctl start nginx"
#     ]
#   }
#   provisioner "local-exec" {
#     command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
#   }