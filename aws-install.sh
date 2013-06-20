#!/bin/bash

prefix=/opt/aws

if [ $# -eq 1 ]; then
	prefix="$1"
elif [ $# -ne 0 ]; then
	echo "Usage: $0 [directory]"
	exit 1
fi

if [ ${EUID} -ne 0 ]; then
	exec sudo $0 "$@"
fi

set -o errexit
set -o nounset

readonly amitools="${prefix}/amitools"
readonly apitools="${prefix}/apitools"
readonly bindir="${prefix}/bin"
mkdir -p "${amitools}" "${apitools}" "${bindir}"

tempdir=$(mktemp -d -t $(basename $0))
trap "rm -r ${tempdir}" EXIT
cd ${tempdir} || exit

_fetch() {
	local url=$1
	local file=$(basename ${url})

	if [[ -e ${file} ]]; then
		head=$(curl -fIs ${url}) || return
		size=$(egrep '^Content-Length:' <<<"${head}"|cut -d' ' -f2|sed 's/.$//')
		sum=$(egrep '^ETag:' <<<"${head}"|cut -d' ' -f2|sed 's/"//g;s/.$//')
		if [[ $(stat -f %z ${file}) == ${size} && $(md5 <${file}) == ${sum} ]]; then
			return 0
		fi
	fi
	curl -#fOR ${url}
}

_unzip() {
	local file=$1
	local dir=$(basename `zipinfo -1 ${file}|head -1`)

	[[ -d ${dir} ]] && rm -rf ${dir}
	unzip -q ${file} -x '*.cmd' || return
	echo ${dir}
}

_link() {
	local source=$1
	local target=$2/${1%-*}

	[[ -L ${target} && $(readlink -n ${target}) == ${source} ]] && return
	ln -hfs ${source} ${target}
}

echo '- EC2 AMI command line tools'
distfile=ec2-ami-tools.zip
_fetch https://s3.amazonaws.com/ec2-downloads/${distfile}
distdir=$(_unzip ${distfile})
version=${distdir##*-}
rsync -a --delete --no-o --no-g ${distdir}/ ${amitools}/ec2-${version}/
_link ec2-${version} ${amitools}
(cd ${bindir} && ln -hfs ../amitools/ec2/bin/ec2-* .)

echo '- Auto Scaling command line tools'
distfile=AutoScaling-2011-01-01.zip
_fetch https://ec2-downloads.s3.amazonaws.com/${distfile}
distdir=$(_unzip ${distfile})
version=${distdir##*-}
rsync -a --delete --no-o --no-g ${distdir}/ ${apitools}/as-${version}/
_link as-${version} ${apitools}
(cd ${bindir} && ln -hfs ../apitools/as/bin/as-* .)

echo '- AWS CloudFormation command line tools'
distfile=AWSCloudFormation-cli.zip
_fetch https://s3.amazonaws.com/cloudformation-cli/${distfile}
distdir=$(_unzip ${distfile})
version=${distdir##*-}
rsync -a --delete --no-o --no-g ${distdir}/ ${apitools}/cfn-${version}/
_link cfn-${version} ${apitools}
(cd ${bindir} && ln -hfs ../apitools/cfn/bin/cfn-* .)

echo '- CloudSearch command line tools'
version=1.0.1.4
distfile=cloud-search-tools-${version}-2013.01.11.tar.gz
_fetch https://s3.amazonaws.com/amazon-cloudsearch-data/${distfile}
tar xzf ${distfile}
rsync -a --no-o --no-g ${distfile%.tar.gz}/ ${apitools}/cs-${version}
_link cs-${version} ${apitools}
(cd ${bindir} && ln -hfs ../apitools/cs/bin/cs-* .)

echo '- EC2 API command line tools'
distfile=ec2-api-tools.zip
_fetch https://s3.amazonaws.com/ec2-downloads/${distfile}
distdir=$(_unzip ${distfile})
version=${distdir##*-}
rsync -a --delete --no-o --no-g ${distdir}/ ${apitools}/ec2-${version}/
_link ec2-${version} ${apitools}
(cd ${bindir} && ln -hfs ../apitools/ec2/bin/ec2* .)

echo '- ElastiCache command line tools'
distfile=AmazonElastiCacheCli-latest.zip
_fetch https://s3.amazonaws.com/elasticache-downloads/${distfile}
distdir=$(_unzip ${distfile})
version=${distdir##*-}
sudo rsync -a --no-o --no-g ${distdir}/ ${apitools}/elasticache-${version}
_link elasticache-${version} ${apitools}
(cd ${bindir} && ln -hfs ../apitools/elasticache/bin/elasticache{,-*} .)

echo '- ELB (Elastic Load Balancer) command line tools'
distfile=ElasticLoadBalancing.zip
_fetch https://ec2-downloads.s3.amazonaws.com/${distfile}
distdir=$(_unzip ${distfile})
version=${distdir##*-}
rsync -a --delete --no-o --no-g ${distdir}/ ${apitools}/elb-${version}/
_link elb-${version} ${apitools}
(cd ${bindir} && ln -hfs ../apitools/elb/bin/elb-* .)

echo '- IAM (Identity and Access Management) commmand line tools'
_fetch https://awsiammedia.s3.amazonaws.com/public/tools/cli/latest/IAMCli.zip
distdir=$(_unzip IAMCli.zip)
version=${distdir##*-}
rsync -a --delete --no-o --no-g ${distdir}/ ${apitools}/iam-${version}/
_link iam-${version} ${apitools}
(cd ${bindir} && ln -hfs ../apitools/iam/bin/iam-* .)

echo '- CloudWatch command line tools'
_fetch https://ec2-downloads.s3.amazonaws.com/CloudWatch-2010-08-01.zip
distdir=$(_unzip CloudWatch-2010-08-01.zip)
version=${distdir##*-}
rsync -a --delete --no-o --no-g ${distdir}/ ${apitools}/mon-${version}/
_link mon-${version} ${apitools}
(cd ${bindir} && ln -hfs ../apitools/mon/bin/mon-* .)

echo '- RDS (Relational Database Service) command line tools'
distfile=RDSCli.zip
_fetch https://s3.amazonaws.com/rds-downloads/${distfile}
distdir=$(_unzip ${distfile})
version=${distdir##*-}
rsync -a --delete --no-o --no-g ${distdir}/ ${apitools}/rds-${version}/
_link rds-${version} ${apitools}
(cd ${bindir} && ln -hfs ../apitools/rds/bin/rds{,-*} .)

echo '- Simple Notification Service (SNS) command line tools'
distfile=SimpleNotificationServiceCli-2010-03-31.zip
_fetch http://sns-public-resources.s3.amazonaws.com/${distfile}
distdir=$(_unzip ${distfile})
version=${distdir##*-}
chmod a+x ${distdir}/bin/*
rsync -a --delete --no-o --no-g ${distdir}/ ${apitools}/sns-${version}/
_link sns-${version} ${apitools}
(cd ${bindir} && ln -hfs ../apitools/sns/bin/sns-* .)

echo '- AWS Import/Export command line tools'
#wget --quiet http://awsimportexport.s3.amazonaws.com/importexport-webservice-tool.zip
#sudo mkdir /usr/local/aws/importexport
#sudo unzip -qq importexport-webservice-tool.zip -d /usr/local/aws/importexport

echo '- Elastic Beanstalk command line tools'
#wget --quiet https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.1.zip
#unzip -qq AWS-ElasticBeanstalk-CLI-*.zip
#sudo rsync -a --no-o --no-g AWS-ElasticBeanstalk-CLI-*/ /usr/local/aws/elasticbeanstalk/

echo '- Elastic MapReduce command line tools'
#wget --quiet http://elasticmapreduce.s3.amazonaws.com/elastic-mapreduce-ruby.zip
#unzip -qq -d elastic-mapreduce-ruby elastic-mapreduce-ruby.zip
#sudo rsync -a --no-o --no-g elastic-mapreduce-ruby/ /usr/local/aws/elasticmapreduce/

echo '- Route 53 (DNS) command line tools'
#sudo mkdir -p /usr/local/aws/route53/bin
#for i in dnscurl.pl route53tobind.pl bindtoroute53.pl route53zone.pl; do
#  sudo wget --quiet --directory-prefix=/usr/local/aws/route53/bin      http://awsmedia.s3.amazonaws.com/catalog/attachments/$i
#  sudo chmod +x /usr/local/aws/route53/bin/$i
#done
#cpanm --sudo --notest --quiet Net::DNS::ZoneFile NetAddr::IP   Net::DNS Net::IP Digest::HMAC Digest::SHA1 Digest::MD5

echo '- CloudFront command line tool'
#sudo wget --quiet --directory-prefix=/usr/local/aws/cloudfront/bin   http://d1nqj4pxyrfw2.cloudfront.net/cfcurl.pl
#sudo chmod +x /usr/local/aws/cloudfront/bin/cfcurl.pl

echo '- S3 command line tools'
#wget --quiet http://s3.amazonaws.com/doc/s3-example-code/s3-curl.zip
#unzip -qq s3-curl.zip
#sudo mkdir -p /usr/local/aws/s3/bin/
#sudo rsync -a --no-o --no-g s3-curl/ /usr/local/aws/s3/bin/
#sudo chmod 755 /usr/local/aws/s3/bin/s3curl.pl

echo '- AWS Data Pipeline command line tools'
#wget --quiet https://s3.amazonaws.com/datapipeline-us-east-1/software/latest/DataPipelineCLI/datapipeline-cli.zip
#unzip -qq datapipeline-cli.zip
#sudo rsync -a --no-o --no-g datapipeline-cli/ /usr/local/aws/datapipeline/

readonly template='credential-file-path.template'
[ -e "${prefix}/${template}" ] || cat >"${prefix}/${template}" <<'END'
AWSAccessKeyId=<Write your AWS access ID>
AWSSecretKey=<Write your AWS secret key>
END

ls -l
