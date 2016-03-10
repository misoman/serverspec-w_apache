require 'spec_helper'

RSpec.shared_examples 'w_apache::blackfire' do
  describe package('blackfire-agent') do
    it { should be_installed }
  end

  describe file('/etc/blackfire/agent') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe service('blackfire-agent') do
    it { should be_enabled }
    it { should be_running }
  end

  describe user('blackfire') do
    it { should exist }
  end

  describe package('blackfire-php') do
    it { should be_installed }
  end

  %w( /etc/php5/fpm/conf.d/blackfire.ini /etc/blackfire/agent ).each do |file|
    describe file(file) do
      it { should be_file }
    end
  end
end
