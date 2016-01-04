require 'spec_helper'

describe 'w_apache::vhosts' do

  [
    { 'main_domain' => 'example.com', 'aliases' => ['www.example.com', 'ex.com'], 'docroot' => '/websites/example.com/www'  },
    { 'main_domain' => 'example2.com',                                            'docroot' => '/websites/example2.com/sub' },
    { 'main_domain' => 'example3.com',                                            'docroot' => '/websites/example3.com/sub' },
    { 'main_domain' => 'docroot-only-vhost.com',                                  'docroot' => '/websites/dov'              }
  ].each do |vhost|

    describe file("#{vhost['docroot']}") do
      it { should be_directory }
      it { should be_owned_by 'www-data' }
      it { should be_grouped_into 'www-data' }
    end

    describe file("/etc/apache2/sites-available/#{vhost['main_domain']}.conf") do
      it { should be_file }
      it { should contain('AllowOverride All').from("<Directory #{vhost['docroot']}>").to('</Directory>') }
      it { should contain("ServerName #{vhost['main_domain']}").before("DocumentRoot #{vhost['docroot']}") }
      it { should contain("ServerAlias #{vhost['aliases']}").after("ServerName #{vhost['main_domain']}") } if vhost.has_key?('aliases')
      it { should contain('DirectoryIndex index.html index.htm index.php') }
    end

    describe file("/etc/apache2/sites-enabled/#{vhost['main_domain']}.conf") do
      it { should be_linked_to "../sites-available/#{vhost['main_domain']}.conf" }
    end
  end
end
