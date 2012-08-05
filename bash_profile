if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

for p in ~/.local/etc/profile.d/*.sh; do
	source $p
done

export AWS_AUTO_SCALING_HOME=/opt/aws/apitools/as
export AWS_CLOUDFORMATION_HOME=/opt/aws/apitools/cfn
export AWS_CLOUDWATCH_HOME=/opt/aws/apitools/mon
export AWS_ELB_HOME=/opt/aws/apitools/elb
export AWS_IAM_HOME=/opt/aws/apitools/iam
export AWS_RDS_HOME=/opt/aws/apitools/rds
export AWS_SNS_HOME=/opt/aws/apitools/sns
export EC2_AMITOOL_HOME=/opt/aws/amitools/ec2
export EC2_HOME=/opt/aws/apitools/ec2
if [[ -x /usr/libexec/java_home ]]; then
	export JAVA_HOME=`/usr/libexec/java_home`
fi
alias aws-context='source aws-context'
