require 'spec_helper'

RSpec.shared_examples 'w_apache::php_ini::session' do

  on = 1
  off = ''
  off_ = 0

  describe php_config('session.save_handler') do
    its(:value) { should eq 'memcached' }
  end

  describe php_config('session.use_cookies') do
    its(:value) { should eq 1 }
  end

  describe php_config('session.use_only_cookiese') do
    its(:value) { should eq off }
  end

  describe php_config('session.name') do
    its(:value) { should eq 'PHPSESSID' }
  end

  describe php_config('session.auto_start') do
    its(:value) { should eq off_ }
  end

  describe php_config('session.cookie_lifetime') do
    its(:value) { should eq 0 }
  end

  describe php_config('session.cookie_path') do
    its(:value) { should eq '/' }
  end

  describe php_config('session.serialize_handler') do
    its(:value) { should eq 'php' }
  end

  describe php_config('session.gc_probability') do
    its(:value) { should eq 1 }
  end

  describe php_config('session.gc_divisor') do
    its(:value) { should eq 1000 }
  end

  describe php_config('session.gc_maxlifetime') do
    its(:value) { should eq 1440 }
  end

  describe php_config('session.cache_limiter') do
    its(:value) { should eq 'nocache' }
  end

  describe php_config('session.cache_expire') do
    its(:value) { should eq 180 }
  end

  describe php_config('session.use_trans_sid') do
    its(:value) { should eq 0 }
  end

  describe php_config('session.hash_function') do
    its(:value) { should eq 1 }
  end

  describe php_config('session.hash_bits_per_character') do
    its(:value) { should eq 5 }
  end

  describe php_config('url_rewriter.tags') do
    its(:value) { should eq 'a=href,area=href,frame=src,input=src,form=fakeentry' }
  end
end
