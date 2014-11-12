require 'spec_helper'

describe 'ec2hostname::service', :type => :class do

  context 'default' do
    let(:pre_condition) { [ "class ec2hostname { $service = 'running' $enable = true }", "include ec2hostname" ] }
    it { should contain_service('ec2hostname').with(
      :ensure => 'running',
      :enable => true
    ) }
  end

  context 'configure service settings' do
    let(:pre_condition) { [ "class ec2hostname { $service = 'stopped' $enable = false }", "include ec2hostname" ] }
    it { should contain_service('ec2hostname').with(
      :ensure => 'stopped',
      :enable => false
    ) }
  end
end