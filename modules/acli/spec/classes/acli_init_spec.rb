require 'spec_helper'

describe 'acli', :type => :class do
  let(:facts) { { :osfamily => 'RedHat', :operatingsystem => 'CentOS', :operatingsystemrelease => '7' } }

  let(:params) { { :user => 'acli', :password => 'acli' } }

  it { should create_class('acli') }

end

