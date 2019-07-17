//resource "aws_security_group" "ssh" {
//    name = "ssh"
//    vpc_id = "${aws_vpc.main.id}"
//     ingress {
//        from_port = 22
//        to_port = 22
//        protocol = "tcp"
//        cidr_blocks = ["0.0.0.0/0"]
//    }
//    tags = {
//    Name = "SSH"
//  }
//}
//
//resource "aws_instance" "EC2" {
//    ami = "ami-0d8f6eb4f641ef691" # this is a special ami preconfigured to do NAT
//    instance_type = "t2.micro"
//    key_name = "testEC2"
//    vpc_security_group_ids = ["${aws_security_group.ssh.id}"]
//    subnet_id = "${aws_subnet.public_subnet.id}"
//    associate_public_ip_address = true
//    
//    tags = {
//    Name = "VPC EC2"
//  }
//   
//}