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

#if which scselect &>/dev/null; then
#	case "`scselect|awk '$1=="*" {print $3}'|tr -d '()'`" in
# 	 Home)
# 	   export http_proxy='http://192.168.2.1:8123'
# 	   export NO_PROXY='localhost'
# 	   ;;
#	esac
#fi

#if [ -s ~/.rvm/scripts/rvm ]; then
#  . ~/.rvm/scripts/rvm
#fi

# vi: set noet ts=2:
