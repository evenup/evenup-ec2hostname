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
  $install_gem = $::ec2hostname::install_gem,
) {

  include ::ec2hostname::params

  if ( $install_gem ) {
    # Packages needed to build the gem
    package { $::ec2hostname::params::gem_package_deps:
      ensure => 'installed',
      before => Package['nokogiri'],
    }

    # Nokogiri is defined to ensure a ruby 1.8.7 version is installed if needed
    package { 'nokogiri':
      ensure   => $::ec2hostname::params::nokogiri_gem_ver,
      provider => 'gem',
    }

    package { 'aws-sdk':
      ensure   => 'installed',
      provider => 'gem',
      require  => Package['nokogiri'],
    }
  }

  file { '/etc/init.d/ec2hostname':
    owner   => 'root',
    group   => 'root',
    mode    => '0550',
    content => template('ec2hostname/ec2hostname.erb'),
  }

}
