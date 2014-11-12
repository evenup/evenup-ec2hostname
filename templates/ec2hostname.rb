#! env ruby
# chkconfig: 35 99 01
# description: EC2 DNS registration
# processname: ec2hostname

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'aws-sdk'
require 'net/http'

hostname = '<%= @hostname %>'
domain = '<%= @domain_name %>'
zone = '<%= @zone_id %>'
ttl = <%= @ttl %>
type = '<%= @type %>'
target = '<%= @target %>'

AWS.config({
  :access_key_id => '<%= @aws_key %>',
  :secret_access_key => '<%= @aws_secret %>'
})

if ( target == 'local-hostname ' || target == 'local-ipv4')
  metadata_endpoint = 'http://169.254.169.254/latest/meta-data/'
  target = Net::HTTP.get( URI.parse( metadata_endpoint + target ) )
end

records = [{
  :alias => [ hostname, domain, '' ] * '.',
  :target => target
}]

rrsets = AWS::Route53::HostedZone.new(zone).rrsets

case ARGV[0]
when 'start', 'restart'
  `touch /var/lock/subsys/ec2hostname`
  records.each{ |record|
    rrset = rrsets[
      record[ :alias ],
      type
    ]

    rrset.delete if rrset.exists?

    rrset = rrsets.create(
      record[ :alias ],
      type,
      :ttl => ttl,
      :resource_records => [
        { :value => record[ :target ] }
      ]
    )
  }
  exit 0
when 'stop'
  records.each{ |record|
    rrset = rrsets[
      record[ :alias ],
      type
    ]

    rrset.delete if rrset.exists?
  }
  exit `rm -f /var/lock/subsys/ec2hostname`
when 'status'
  if File.exists?('/var/lock/subsys/ec2hostname')
    puts "Running"
    exit 0
  else
    puts "Stopped"
    exit 3
  end
end

puts "Valid commands are start, restart, stop, and status"
exit 3
