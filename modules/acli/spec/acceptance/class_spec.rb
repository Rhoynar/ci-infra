require 'spec_helper_acceptance'

describe 'acli classes' do

  context 'install/configure' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'acli': user => 'testuser', password => 'testpass'}
      EOS

      # Ensure puppet ssl dir is clean
      shell("rm -rf /var/lib/puppet/ssl")

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/opt/acli') do
      it { should be_linked_to '/opt/atlassian-cli-3.9.0'}
    end

    describe file('/opt/acli/atlassian.sh') do
      its(:content) { should match /user=testuser/ }
      its(:content) { should match /password=testpass/ }
    end
  end # install/config

end
