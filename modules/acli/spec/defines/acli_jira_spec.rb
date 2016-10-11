require 'spec_helper'

describe 'acli::jira', :type => :define do
  let(:title) { 'audit_task' }

  context 'default' do
    let(:params) { {
      :project  => 'Test Project',
      :summary  => 'This is an automated test ticket'
    } }

    it { should contain_cron('jira_audit_task').with(
      :ensure   => 'present',
      :command  => "/opt/acli/atlassian.sh jira --action createIssue --project 'Test Project' --summary 'This is an automated test ticket' --type 'task'",
      :hour     => 0,
      :minute   => 1,
      :month    => 1,
      :monthday => 1,
      :weekday  => '*'
    )}
  end

  context 'allow setting cron schedule' do
    let(:params) { {
      :project  => 'Test Project',
      :summary  => 'This is an automated test ticket',
      :hour     => 2,
      :hour     => 2,
      :minute   => 2,
      :month    => 2,
      :monthday => 2,
      :weekday  => 2
    } }

    it { should contain_cron('jira_audit_task').with(
      :ensure   => 'present',
      :command  => "/opt/acli/atlassian.sh jira --action createIssue --project 'Test Project' --summary 'This is an automated test ticket' --type 'task'",
      :hour     => 2,
      :hour     => 2,
      :minute   => 2,
      :month    => 2,
      :monthday => 2,
      :weekday  => 2
    )}
  end

  context 'set additional fields' do
    let(:params) { {
      :project      => 'Test Project',
      :summary      => 'This is an automated test ticket',
      :type         => 'test',
      :labels       => 'a b c',
      :assignee     => 'testuser',
      :description  => 'This task is for some neat things',
      :parent       => 'TP-1234'
    } }

    it { should contain_cron('jira_audit_task').with(
      :command  => "/opt/acli/atlassian.sh jira --action createIssue --project 'Test Project' --summary 'This is an automated test ticket' --type 'test' --labels 'a b c' --assignee 'testuser' --description 'This task is for some neat things' --parent 'TP-1234'"
    ) }
  end

  context 'remove cron entry' do
    let(:params) { {
      :project  => 'Test Project',
      :summary  => 'This is an automated test ticket',
      :ensure   => 'absent'
    } }

    it { should contain_cron('jira_audit_task').with(:ensure => 'absent') }
  end

end
