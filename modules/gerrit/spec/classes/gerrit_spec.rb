require 'spec_helper'
require 'rspec-puppet'
require 'hiera'
require 'facter'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'gerrit' do
  context 'in module gerrit' do
    let(:hiera_config) { hiera_config }
    let(:facts) { {
        :osfamily => 'RedHat',
        :operatingsystem => 'CentOS',
        :operatingsystemrelease => '6.4',
        :concat_basedir => '/dne',
    } }
    let(:params) { {
        :source => '/tmp/gerrit.war',
        :target => '/srv/gerrit'
    } }
    it { should contain_class('gerrit') }
  end
end # fin describe 'gerrit'
