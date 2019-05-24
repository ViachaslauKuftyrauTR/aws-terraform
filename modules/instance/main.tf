resource "aws_instance" "kuftyrau_instance" {
  count         = "${var.instance_count}"
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  key_name      = "${lookup(var.keyname, var.region)}"
  # availability_zone      = "${var.region == "us-east-1" ? element(var.azs_ue1, count.index) : element(var.azs_ue2, count.index)}"

  vpc_security_group_ids = ["${var.security_group_id}"]
  
  subnet_id     = "${var.subnet_id}"
  
  connection {
    user        = "${var.ssh_username}"
    private_key ="${file("/mnt/d/9068kuftyrau-ohio.pem")}"
    # private_key ="${file("/home/vkuftyrau/Downloads/kuftyrau-home.pem")}"
    agent       = true
    timeout     = "3m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo su -c 'echo $HOSTNAME > /var/www/html/index.html'",
      "sudo nginx -s start",
      "sudo systemctl enable nginx"
    ]
  }

  tags {
    name = "Node"
  }
}