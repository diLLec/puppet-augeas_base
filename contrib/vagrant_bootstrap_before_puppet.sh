#!/bin/bash

if [ ! -e /etc/yum.repos.d/puppetlabs-pc1.repo ]; then
    yum -y install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
fi

if (! git --version ); then
    yum -y install git
fi

if (! ruby --version ); then
    yum install -y centos-release-scl
    yum install -y rh-ruby23 rh-ruby23-ruby-devel
    yum -y install ruby ruby-devel.x86_64 gcc.x86_64 gcc-c++.x86_64
    scl enable rh-ruby23 -- gem install bundler
    yum -y install zlib zlib-devel
fi



if ! (puppet --version > /dev/null 2>&1); then
    if (yum -y install puppet-agent); then

        # disable EC2 facter module, since that would query EC2 api everytime puppet runs
        # see: https://github.com/puppetlabs/facter/blob/master/lib/src/facts/resolvers/ec2_resolver.cc#L117
        mkdir /etc/puppetlabs/facter/
        cat <<'EOF' > /etc/puppetlabs/facter/facter.conf
facts : {
 # for valid blocklist entries, see fact schema
 blocklist : [ "EC2" ],
}
EOF
    fi

fi

cd /etc/puppet/modules/augeas_base
scl enable rh-ruby23 -- bundle install --gemfile Gemfile

