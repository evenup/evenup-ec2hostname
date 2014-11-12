# == Class: ec2hostname::install
#
# This class installs the ec2hostname init script and optionally the aws-sdk gem
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
#
# === Copyright
#
# Copyright 2014 EvenUp.
#
class ec2hostname::install (
  $aws_key,
  $aws_secret,
  $hostname,
  $domain,
  $ttl,
  $type,
  $target,
  $zone,
) {

  if ( $ec2hostname::install_gem ) {
    package { 'aws-sdk':
      ensure   => 'installed',
      provider => 'gem',
    }
  }

  file { '/etc/init.d/ec2hostname':
    owner   => 'root',
    group   => 'root',
    mode    => '0550',
    content => template('ec2hostname/ec2hostname.erb'),
  }

}
