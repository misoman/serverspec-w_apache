require 'spec_helper'

RSpec.shared_examples 'w_apache::ssl' do

  describe file('/etc/apache2/mods-enabled/ssl.conf') do
    it { should be_linked_to "../mods-available/ssl.conf" }
    it { should contain 'SSLPassPhraseDialog exec:/etc/ssl/passphrase' }
  end

  [
    {'main_domain'=> 'ssl.example.com', 'docroot'=> '/websites/example.com/ssl', 'aliases'=> ['ssl2.example.com'], 'ssl'=> true }
  ].each do |vhost|

    describe file("/etc/ssl/certs/#{vhost['main_domain']}.crt") do
      it { should be_file }
    end

    describe file("/etc/ssl/private/#{vhost['main_domain']}.key") do
      it { should be_file }
    end

    describe file("/etc/apache2/sites-available/#{vhost['main_domain']}-ssl.conf") do
      it { should be_file }
      it { should contain('<VirtualHost *:443>') }
      it { should contain('AllowOverride All').from("<Directory #{vhost['docroot']}>").to('</Directory>') }
      it { should contain("ServerName #{vhost['main_domain']}").before("DocumentRoot #{vhost['docroot']}") }
      it { should contain("ServerAlias #{vhost['aliases']}").after("ServerName #{vhost['main_domain']}") }
      it { should contain('DirectoryIndex index.html index.htm index.php') }
    end

    describe file("/etc/apache2/sites-enabled/#{vhost['main_domain']}-ssl.conf") do
      it { should be_linked_to "../sites-available/#{vhost['main_domain']}-ssl.conf" }
    end
  end

  describe file('/etc/ssl/passphrase') do
    it { should be_file }
    it { should be_mode 755 }
  end
end
