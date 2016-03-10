require 'spec_helper'

RSpec.shared_examples 'w_apache::newrelic_app' do
  describe file('/etc/init.d/newrelic-daemon') do
    it { should be_file }
    it { should be_executable }
  end

  describe file('/etc/php5/fpm/conf.d/newrelic.ini') do
    it { should_not exist }
  end
end
