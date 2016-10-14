require 'spec_helper'

describe 'w_apache::composer' do

  describe file('/usr/local/bin/composer') do
    it { should be_file }
  end

  describe file('/var/www/composer') do
    it { should be_directory }
    it { should be_owned_by 'www-data' }
    it { should be_grouped_into 'www-data' }
  end
  
  describe command('composer') do
 	let(:sudo_options) { '-u www-data -i' }
    its(:stdout) { should match /Composer version/ }
    its(:exit_status) { should eq 0 }
  end

  describe command('composer -h') do
    let(:sudo_options) { '-u www-data -i' }
    its(:exit_status) { should eq 0 }
  end
  
end