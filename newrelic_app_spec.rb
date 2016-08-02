require 'spec_helper'

RSpec.shared_examples 'w_apache::newrelic_app' do
  describe file('/etc/init.d/newrelic-daemon') do
    it { should be_file }
    it { should be_executable }
  end

  %w(fpm cli).each do |execution_type|

    describe file("/etc/php/#{php_minor_version}/#{execution_type}/conf.d/newrelic.ini") do
      it { should_not exist }
    end
  end
end
