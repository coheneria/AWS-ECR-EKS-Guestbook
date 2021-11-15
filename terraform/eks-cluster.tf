resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks-role.arn
  version = "1.21"
  vpc_config {
    endpoint_private_access = false
    endpoint_public_access = true
    subnet_ids = [
        aws_subnet.subnet-1.id, 
        aws_subnet.subnet-2.id,
        aws_subnet.subnet-3.id,
        aws_subnet.subnet-4.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon-eks-cluster-policy,
  ]
}