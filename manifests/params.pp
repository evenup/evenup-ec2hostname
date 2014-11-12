# == Class: ec2hostname::params
#
# This class sets the defaults for the ec2hostname module
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
class ec2hostname::params {

  $hostname = ::hostname
  $domain   = inline_template("<%= domain = @fqdn.split('.'); domain.shift ; domain.join('.') %>")
  $ttl      = 60
  $type     = 'CNAME'
  $target   = 'local-hostname'
  $service  = 'running'
  $enable   = true

}
