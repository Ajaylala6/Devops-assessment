provider "aws" {
  region = "us-east-1" 
}

data "aws_eks_cluster" "cluster" {
  name = "test"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "test"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}