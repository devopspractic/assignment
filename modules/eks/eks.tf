resource "aws_iam_role" "eks_cluster"{
 name = "eks-cluster"

 assume_role_policy = <<POLICY
 {
 "VERSION": "2012-12-17",
 "Statement": [
    {
      "Effect": "Allow"
      "Principal": {
         "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
 ]
 }
 POLICY
}


resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy"{

 policy_arn = "arn:aws:iam::aws:policy//AmazonEKSClusterPolicy"
 role = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "eks" {
  name     = "eks"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {

    endpoint_private_access = true
    endpoint_public_access = false
    security_group_ids = aws_security_group.ssh-allowed.id

    subnet_ids = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id,
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
  ]
}
