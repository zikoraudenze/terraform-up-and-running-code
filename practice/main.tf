resource "aws-launch_configuration" "example" {
    image_id = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.instance.id]

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF 
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"
    ingress{
      from_port   = var.server_port
      to_port     = var.server_port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "instance-security-group"
    }                                                                       
}

variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type        = number  
    default     = 8080
}

output "public_ip" {
    value = aws_instance.example.public_ip
    description = "The public IP address of the web server"
}