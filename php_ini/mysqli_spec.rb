require 'spec_helper'

RSpec.shared_examples 'w_apache::php_ini::mysqli' do

  on = 1
  off = ''
  off_ = 0

  describe php_config('mysql.max_persistent') do
    its(:value) { should eq '-1' }
  end

  describe php_config('mysql.allow_persistent') do
    its(:value) { should eq on }
  end

  describe php_config('mysql.max_links') do
    its(:value) { should eq '-1' }
  end

  describe php_config('mysql.cache_size') do
    its(:value) { should eq 2000 }
  end

  describe php_config('mysqli.default_port') do
    its(:value) { should eq 3306 }
  end

  describe php_config('mysqli.reconnect') do
    its(:value) { should eq off }
  end
end
