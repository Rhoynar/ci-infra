require 'spec_helper'

describe 'acli', :type => :class do
  let(:facts) { { :osfamily => 'RedHat', :operatingsystem => 'CentOS', :operatingsystemrelease => '7' } }

  let(:params) { { :user => 'acli', :password => 'acli' } }

  it { should create_class('acli::config') }
  it { should contain_file('/opt/acli/atlassian.sh') }

  context "no *_servers set" do
    it { should contain_file('/opt/acli/atlassian.sh').without(:content => /"\$application" = "confluence"/) }
    it { should contain_file('/opt/acli/atlassian.sh').without(:content => /"\$application" = "jira"/) }
    it { should contain_file('/opt/acli/atlassian.sh').without(:content => /"\$application" = "fisheye"/) }
    it { should contain_file('/opt/acli/atlassian.sh').without(:content => /"\$application" = "crucible"/) }
    it { should contain_file('/opt/acli/atlassian.sh').without(:content => /"\$application" = "bamboo"/) }
    it { should contain_file('/opt/acli/atlassian.sh').without(:content => /"\$application" = "stash"/) }
  end

  context "each server set" do
    let(:params) { {
      :user => 'acli',
      :password => 'acli',
      :confluence_server => 'http://confluence.example.com',
      :jira_server => 'http://jira.example.com',
      :fisheye_server => 'http://fisheye.example.com',
      :crucible_server => 'http://crucible.example.com',
      :bamboo_server => 'http://bamboo.example.com',
      :stash_server => 'http://stash.example.com'
    } }
    it { should contain_file('/opt/acli/atlassian.sh').with(:content => /"\$application" = "confluence"/) }
    it { should contain_file('/opt/acli/atlassian.sh').with(:content => /"\$application" = "jira"/) }
    it { should contain_file('/opt/acli/atlassian.sh').with(:content => /"\$application" = "fisheye"/) }
    it { should contain_file('/opt/acli/atlassian.sh').with(:content => /"\$application" = "crucible"/) }
    it { should contain_file('/opt/acli/atlassian.sh').with(:content => /"\$application" = "bamboo"/) }
    it { should contain_file('/opt/acli/atlassian.sh').with(:content => /"\$application" = "stash"/) }
  end

  context "configuring variables" do
    let(:params) { {
      :user => 'acli',
      :password => 'acli',
      :version  => '3.7.0',
      :confluence_server => 'http://confluence.example.com',
      :jira_server => 'http://jira.example.com',
      :fisheye_server => 'http://fisheye.example.com',
      :crucible_server => 'http://crucible.example.com',
      :bamboo_server => 'http://bamboo.example.com',
      :stash_server => 'http://stash.example.com'
    } }
    it { should contain_file('/opt/acli/atlassian.sh').with(:content => /"confluence-cli-3.7.0.jar --server http:\/\/confluence.example.com --user \$user --password \$password/) }
    it { should contain_file('/opt/acli/atlassian.sh').with(:content => /"jira-cli-3.7.0.jar --server http:\/\/jira.example.com --user \$user --password \$password/) }
    it { should contain_file('/opt/acli/atlassian.sh').with(:content => /"fisheye-cli-3.7.0.jar --server http:\/\/fisheye.example.com --user \$user --password \$password/) }
    it { should contain_file('/opt/acli/atlassian.sh').with(:content => /"crucible-cli-3.7.0.jar --server http:\/\/crucible.example.com --user \$user --password \$password/) }
    it { should contain_file('/opt/acli/atlassian.sh').with(:content => /"bamboo-cli-3.7.0.jar --server http:\/\/bamboo.example.com --user \$user --password \$password/) }
    it { should contain_file('/opt/acli/atlassian.sh').with(:content => /"stash-cli-3.7.0.jar --server http:\/\/stash.example.com --user \$user --password \$password/) }
  end

  context 'if present on first service' do
    context 'no el' do
      let(:params) { {
        :user => 'acli',
        :password => 'acli',
        :confluence_server => 'http://confluence.example.com'
      } }
      it { should contain_file('/opt/acli/atlassian.sh').with(:content => /if \[ "\$application" = "confluence" \]; then/) }
    end

    context 'with el' do
      let(:params) { {
        :user => 'acli',
        :password => 'acli',
        :jira_server => 'http://jira.example.com'
      } }
      it { should contain_file('/opt/acli/atlassian.sh').with(:content => /if \[ "\$application" = "jira" \]; then/) }
    end
  end

  context 'elif on 2nd service' do
    let(:params) { {
      :user => 'acli',
      :password => 'acli',
      :confluence_server => 'http://confluence.example.com',
      :jira_server => 'http://jira.example.com'
    } }
    it { should contain_file('/opt/acli/atlassian.sh').with(:content => /elif \[ "\$application" = "jira" \]; then/) }
  end

end
