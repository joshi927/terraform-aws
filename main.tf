resource "aws_vpc" "vpcnew" {
  cidr_block = "10.0.0.0/16"

  tags = {
   Name = "vpcnew"
  }
}

resource "aws_subnet" "pub1" {
  vpc_id     = aws_vpc.vpcnew.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "pub1"
  }
}

resource "aws_subnet" "pub2" {
  vpc_id     = aws_vpc.vpcnew.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "pub2"
  }
}

resource "aws_subnet" "pvt1" {
  vpc_id     = aws_vpc.vpcnew.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "pvt1"
  }
}

resource "aws_subnet" "pvt2" {
  vpc_id     = aws_vpc.vpcnew.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "pvt2"
  }
}

resource "aws_internet_gateway" "iggw" {
  vpc_id = aws_vpc.vpcnew.id

  tags = {
    Name = "iggw"
  }
}

resource "aws_nat_gateway" "natgw1" {
  allocation_id = aws_eip.nateip1.id
  subnet_id     = aws_subnet.pub1.id

  tags = {
    Name = "natgw1"
  }
}

resource "aws_nat_gateway" "natgw2" {
  allocation_id = aws_eip.nateip2.id
  subnet_id     = aws_subnet.pub2.id

  tags = {
    Name = "natgw1"
  }
}


resource "aws_eip" "nateip1" {
  vpc      = true
}

resource "aws_eip" "nateip2" {
  vpc      = true
}

resource "aws_route_table" "routetblpub" {
  vpc_id = aws_vpc.vpcnew.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iggw.id
  }
  tags = {
    Name = "routetblpub"
  }
}

resource "aws_route_table" "routetblpvt1" {
  vpc_id = aws_vpc.vpcnew.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw1.id
  }
  tags = {
    Name = "routetblpvt1"
  }
}

resource "aws_route_table" "routetblpvt2" {
  vpc_id = aws_vpc.vpcnew.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw2.id
  }
  tags = {
    Name = "routetblpvt2"
  }
}

resource "aws_route_table_association" "pub_tbl_assoc1" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.routetblpub.id
}

resource "aws_route_table_association" "pub_tbl_assoc2" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.routetblpub.id
}

resource "aws_route_table_association" "pvt_tbl_assoc1" {
  subnet_id      = aws_subnet.pvt1.id
  route_table_id = aws_route_table.routetblpvt1.id
}

resource "aws_route_table_association" "pvt_tbl_assoc2" {
  subnet_id      = aws_subnet.pvt2.id
  route_table_id = aws_route_table.routetblpvt2.id
}

