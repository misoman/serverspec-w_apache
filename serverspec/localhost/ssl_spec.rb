require 'spec_helper'

describe 'w_apache::ssl' do

  describe file('/etc/apache2/mods-enabled/ssl.conf') do
    it { should be_linked_to "../mods-available/ssl.conf" }
    it { should contain 'SSLPassPhraseDialog exec:/etc/ssl/passphrase' }
  end

  [
    {'id'=> 'ssl.example.com', 
    'cert_file'=> '/etc/ssl/certs/ssl.example.com.crt', 
    'cert_inter_file'=> '/etc/ssl/certs/ssl.example.comCA.crt', 
    'cert_key_file'=> '/etc/ssl/private/ssl.example.com.key', 
    'ssl_path'=> '/websites/example.com/ssl', 
    'ssl_aliases'=> ['ssl2.example.com'] },
    {'id'=> 'www.newexample.com', 
    'cert_file'=> '/etc/ssl/certs/www.newexample.com.crt', 
    'cert_inter_file'=> '/etc/ssl/certs/www.newexample.comCA.crt', 
    'cert_key_file'=> '/etc/ssl/private/www.newexample.com.key', 
    'ssl_path'=> '/websites/newexample.com/www', 
    'ssl_aliases'=> ['newexample.com'] }
  ].each do |cert_info|

    describe file("/etc/ssl/certs/#{cert_info['id']}.crt") do
      it { should be_file }
    end
  
    describe file("/etc/ssl/certs/#{cert_info['id']}CA.crt") do
      it { should be_file }
    end
  
    describe file("/etc/ssl/private/#{cert_info['id']}.key") do
      it { should be_file }
    end

    describe file("/etc/apache2/sites-available/#{cert_info['id']}-ssl.conf") do 
      it { should be_file }
      it { should contain('<VirtualHost *:443>') }  
      it { should contain('AllowOverride All').from("<Directory #{cert_info['ssl_path']}>").to('</Directory>') }
      it { should contain("ServerName #{cert_info['id']}").before("DocumentRoot /websites/#{cert_info['ssl_path']}>") }
      it { should contain("ServerAlias #{cert_info['ssl_aliases']}").after("ServerName #{cert_info['id']}") }
      it { should contain('DirectoryIndex index.html index.htm index.php') }
    end

    describe file("/etc/apache2/sites-enabled/#{cert_info['id']}-ssl.conf") do
      it { should be_linked_to "../sites-available/#{cert_info['id']}-ssl.conf" }
    end
    
  end
  
  describe file('/etc/ssl/passphrase') do
    it { should be_file }
    it { should be_mode 755 }
  end
  
end