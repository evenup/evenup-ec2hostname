# == Class: ec2hostname::service
#
# This class manages the ec2hostname service
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
class ec2hostname::service {

  service { 'ec2hostname':
    ensure => $::ec2hostname::service,
    enable => $::ec2hostname::enable,
  }

}
