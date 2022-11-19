      for key,value in var.egress:
      key => value
      if key != "ssh"resource "aws_vpc" "myvpc" {
  cidr_block = "10.10.10.0/24"
}

resource "aws_security_group" "dynamic_test" {
  name   = "dynamic_test"
  vpc_id = aws_vpc.myvpc.id

  dynamic "egress" {
    for_each = {
      for key,value in var.egress:
      key => value
      if key != "ssh"  
   } 

    content {
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

