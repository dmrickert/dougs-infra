# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "dougkeypair"
  public_key = "${file("${var.key_path}")}"
}

# Define bastion inside the public subnet
resource "aws_instance" "bastion" {
   ami  = "${var.ami}"
   instance_type = "t2.nano"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgbast.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   #user_data = "${file("install.sh")}"

  tags {
    Name = "bastion"
  }
}

# Define ffbot server inside the private subnet
resource "aws_instance" "ffbot-denver" {
   ami  = "${var.ami}"
   instance_type = "t2.nano"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgpub.id}"]
   associate_public_ip_address = true
   source_dest_check = false

  tags {
    Name = "ffbot-denver"
  }
}
