resource "aws_eks_node_group" "eks-node-group" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  node_group_name = "eks-node-group"

  # Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group.
  node_role_arn = aws_iam_role.eks-node-groups.arn

  # Identifiers of EC2 Subnets to associate with the EKS Node Group. 
  # These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME 
  # (where CLUSTER_NAME is replaced with the name of the EKS Cluster).
  subnet_ids = [
    aws_subnet.subnet-3.id, 
    aws_subnet.subnet-4.id,
  ]

  # Configuration block with scaling settings
  scaling_config {
    desired_size = 2
    max_size = 3
    min_size = 1
  }

  capacity_type = "SPOT"
  force_update_version = false
  instance_types = ["t3.small"]
  labels = {
    role = "eks-node-group"
  }
  version = "1.21"

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}