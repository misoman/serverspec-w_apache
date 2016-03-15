require 'spec_helper'

RSpec.shared_examples 'w_apache::php_ini::mysql' do

  on = 1
  off = ''
  off_ = 0

  describe php_config('sql.safe_mode') do
    its(:value) { should eq off }
  end

  describe php_config('mysql.allow_local_infile') do
    its(:value) { should eq on }
  end

  describe php_config('mysql.allow_persistent') do
    its(:value) { should eq on }
  end

  describe php_config('mysql.cache_size') do
    its(:value) { should eq 2000 }
  end

  describe php_config('mysql.max_persistent') do
    its(:value) { should eq '-1' }
  end

  describe php_config('mysql.max_links') do
    its(:value) { should eq '-1' }
  end

 describe php_config('mysql.connect_timeout') do
    its(:value) { should eq 60 }
  end
end
