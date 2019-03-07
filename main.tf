provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.region}"
}

/*provider "digitalocean" {
  token = "${var.do_token}"
}*/

/*provider "google" {
  credentials = "${file("${var.credentials_file_path}")}"
  project = "${var.project}"
  region = "${var.gcp_region}"
}*/
resource "aws_vpc" "alain" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
}

resource "aws_subnet" "alain-subnet" {
    vpc_id = "${aws_vpc.alain.id}"
    cidr_block = "10.0.0.10/24"
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.alain.id}"
}

resource "aws_route_table" "default" {
    vpc_id = "${aws_vpc.alain.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }
}

resource "aws_route_table_association" "default" {
    subnet_id = "${aws_subnet.alain-subnet.id}"
    route_table_id = "${aws_route_table.default.id}"
}

resource "aws_instance" "kali-linux" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.kali-linux.id}"
  vpc = true
}

resource "aws_security_group" "dns-rdir" {
    name = "dns-redirector"
    vpc_id = "${aws_vpc.alain.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 53
        to_port = 53
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 53
        to_port = 53
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "http-rdir" {
    name = "http-redirector"
    vpc_id = "${aws_vpc.alain.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 53
        to_port = 53
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

