[ -e /opt/aws ] && {
	export AWS_AUTO_SCALING_HOME=/opt/aws/apitools/as
	export AWS_CLOUDFORMATION_HOME=/opt/aws/apitools/cfn
	export AWS_CLOUDWATCH_HOME=/opt/aws/apitools/mon
	export AWS_ELASTICACHE_HOME=/opt/aws/apitools/elasticache
	export AWS_ELB_HOME=/opt/aws/apitools/elb
	export AWS_IAM_HOME=/opt/aws/apitools/iam
	export AWS_RDS_HOME=/opt/aws/apitools/rds
	export AWS_SNS_HOME=/opt/aws/apitools/sns
	export CS_HOME=/opt/aws/apitools/cs
	export EC2_AMITOOL_HOME=/opt/aws/amitools/ec2
	export EC2_HOME=/opt/aws/apitools/ec2

	path=(/opt/aws/bin $path)
}
