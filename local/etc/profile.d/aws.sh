function aws-context {
	if [ $# -eq 0 ]; then
		[ -n "$AWS_ACCESS_KEY"      ] && echo AWS_ACCESS_KEY=$AWS_ACCESS_KEY
		[ -n "$AWS_ACCESS_KEY_ID"   ] && echo AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
		[ -n "$AWS_CREDENTIAL_FILE" ] && echo AWS_CREDENTIAL_FILE=$AWS_CREDENTIAL_FILE
		[ -n "$AWS_REGION"          ] && echo AWS_REGION=$AWS_REGION
		[ -n "$BOTO_CONFIG"         ] && echo BOTO_CONFIG=$BOTO_CONFIG
		[ -n "$EC2_CERT"            ] && echo EC2_CERT=$EC2_CERT
		[ -n "$EC2_PRIVATE_KEY"     ] && echo EC2_KEY=$EC2_PRIVATE_KEY
		[ -n "$EC2_REGION"          ] && echo EC2_REGION=$EC2_REGION
		[ -n "$EC2_URL"             ] && echo EC2_URL=$EC2_URL
		return 0
	fi

	if [ $# -eq 3 ]; then
		if [ "$1" == "-r" ]; then
			region=$2; shift 2
		fi
	fi
	if [ $# -ne 1 -o "$1" = '-h' ]; then
		echo "usage: ${BASH_SOURCE##*/} [-r region] account" >&2; return 2
	fi

	credentials=($(ls $HOME/.aws/$1.{boto,credentials,crt,key} 2>/dev/null))
	if [ ${#credentials[@]} -eq 0 ]; then
		echo "${BASH_SOURCE##*/}: $1: No such credentials" >&2; return 2
	fi

	export AWS_REGION="${region:-${AWS_DEFAULT_REGION:-us-east-1}}"
	export EC2_REGION=$AWS_REGION
	export EC2_URL="https://ec2.$EC2_REGION.amazonaws.com"
	unset AWS_CREDENTIAL_FILE BOTO_CONFIG EC2_CERT EC2_PRIVATE_KEY
	unset AWS_ACCESS_KEY AWS_SECRET_KEY AWS_DELEGATION_TOKEN

	for credential in ${credentials[@]}; do
		case "$credential" in
			*.boto)        export BOTO_CONFIG=$credential;;
			*.credentials) export AWS_CREDENTIAL_FILE=$credential;;
			*.crt)         export EC2_CERT=$credential;;
			*.key)         export EC2_PRIVATE_KEY=$credential;;
		esac
	done

	if [ -n "$AWS_CREDENTIAL_FILE" ]; then
		AWS_ACCESS_KEY=`egrep ^AWSAccessKeyId= $AWS_CREDENTIAL_FILE|cut -d= -f2`
		AWS_SECRET_KEY=`egrep ^AWSSecretKey= $AWS_CREDENTIAL_FILE|cut -d= -f2`
		export AWS_ACCESS_KEY AWS_SECRET_KEY
		# AWS SDK for Ruby uses different names:
		AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY}
		AWS_SECRET_ACCESS_KEY=${AWS_SECRET_KEY}
		export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
	fi
}

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
}

export AWS_DEFAULT_REGION='eu-west-1'
