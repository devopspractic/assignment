#creating roles for nodes
resource "aws_iam_role" "nodes_role"{
 name = "general_nodes"


 assume_role_policy = <<POLICY
 {
 "VERSION": "2012-12-17",
 "Statement": [
    {
      "Effect": "Allow"
      "Principal": {
         "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
 ]
 }
 POLICY
}
#attaching iam policy to access EFS
resource "aws_iam_policy" "efs" {
  name = "efs"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:Describe*",
        "elasticfilesystem:Access*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# attaching policy to roles
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general"{

 policy_arn = "arn:aws:iam::aws:policy//AmazonEKSWorkerNodePolicy"
 role = aws_iam_role.nodes_role.name
}
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general"{

 policy_arn = "arn:aws:iam::aws:policy//AmazonEKS_CNI_Policy"
 role = aws_iam_role.nodes_role.name
}
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only"{

 policy_arn = "arn:aws:iam::aws:policy//AmazonEC2ContainerRegistryReadOnly"
 role = aws_iam_role.nodes_role.name
}


#Resource aws_eks_node_group

resource "aws_eks_node_group" "nodes_general" {
  node_group_name = "nodes_general"
  cluster_name = aws_eks_cluster.eks.name
  node_role_arn = aws_iam_role.nodes_role.arn

#attaching private subnets for nodes
subnet_ids = [
  aws_subnet.private_1.id,
  aws_subnet.private_2.id
]

scalling_config {
  desired_size = 1
  max_size = 1
  min_size = 1
}
security_groups = [aws_security_group.rds_sg.id]
capacity_type = "ON_DEMAND"
disk_size = 20
instance_type = ["t3.small"]
labels = {
  role = "nodes_general"
}
version = "1.18"
depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only
  ]
}
