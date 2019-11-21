provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region     = "${var.AWS_REGION}"
}

resource "aws_key_pair" "example" {
  key_name = "examplekey"
  public_key = file("~/.ssh/id_rsa.pub")
 }

resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.example.id
}

resource "aws_instance" "example" {
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example.key_name
  depends_on    = [aws_key_pair.example]
  tags = {
    Name = "terraform-test"
 }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt -y update",
      "sudo apt -y install nginx",
      "sudo systemctl start nginx"
    ]
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }


}


# New resource for the S3 bucket our application will use.
resource "aws_s3_bucket" "example" {
  # NOTE: S3 bucket names must be unique across _all_ AWS accounts, so
  # this name must be changed before applying this example to avoid naming
  # conflicts.
  bucket = "terraform-getting-s8td-sanusatya"
  acl    = "private"
  depends_on = [aws_instance.example]

}
