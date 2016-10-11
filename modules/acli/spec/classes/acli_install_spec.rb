require 'spec_helper'

describe 'acli', :type => :class do
  let(:facts) { { :osfamily => 'RedHat', :operatingsystem => 'CentOS', :operatingsystemrelease => '7' } }

  let(:params) { { :user => 'acli', :password => 'acli' } }

  it { should create_class('acli::install') }

  it { should contain_exec('fetch_acli').with(:command => '/usr/bin/curl -o atlassian-cli-3.9.0-distribution.zip https://bobswift.atlassian.net/wiki/download/attachments/16285777/atlassian-cli-3.9.0-distribution.zip') }
  it { should contain_exec('extract_acli').with(:command => 'unzip /tmp/atlassian-cli-3.9.0-distribution.zip -d /opt/') }
  it { should contain_file('/opt/acli').with(:target => '/opt/atlassian-cli-3.9.0') }

  context "set and version source" do
    let(:params) { { :user => 'acli', :password => 'acli', :version => '3.0.0', :source => 'http://files.example.com' } }
    it { should contain_exec('fetch_acli').with(:command => '/usr/bin/curl -o atlassian-cli-3.0.0-distribution.zip http://files.example.com/atlassian-cli-3.0.0-distribution.zip') }
    it { should contain_exec('extract_acli').with(:command => 'unzip /tmp/atlassian-cli-3.0.0-distribution.zip -d /opt/') }
    it { should contain_file('/opt/acli').with(:target => '/opt/atlassian-cli-3.0.0') }
  end

end

