require 'spec_helper'

RSpec.shared_examples 'w_apache::phalcon' do

  describe command('php -m') do
    its(:stdout) { should match /phalcon/ }
  end

  describe file("/etc/php/#{php_minor_version}/mods-available/phalcon.ini") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
  end

  %w(fpm cli).each do |php_execution_type|
    describe file("/etc/php/#{php_minor_version}/#{php_execution_type}/conf.d/20-phalcon.ini") do
      it { should be_symlink }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end
  end
end
