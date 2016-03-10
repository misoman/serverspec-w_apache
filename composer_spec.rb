require 'spec_helper'

RSpec.shared_examples 'w_apache::composer' do

  describe file('/usr/local/bin/composer') do
    it { should be_file }
  end

  describe command('composer') do
    its(:stdout) { should match /Composer version/ }
    its(:exit_status) { should eq 0 }
  end
end
