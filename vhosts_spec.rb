require 'spec_helper'

RSpec.shared_examples 'w_apache::vhosts' do

	%w( /websites/examplewebsite.com/www /websites/examplewebsite.com/admin ).each do |docroot|
		describe file("#{docroot}") do
		  it { should be_directory }
		  it { should be_owned_by 'www-data' }
		  it { should be_grouped_into 'www-data' }
		end
	end

	[
		{'main_domain'=> 'examplewebsite.com', 'docroot'=> '/websites/examplewebsite.com/www', 'aliases'=> ['www.examplewebsite.com'] },
		{'main_domain'=> 'admin.examplewebsite.com', 'docroot'=> '/websites/examplewebsite.com/admin', 'aliases'=> ['admin.examplewebsite.com'] }
	].each do |vhost|

	 	describe file("/etc/apache2/sites-available/#{vhost['main_domain']}.conf") do
	     it { should be_file }
	     it { should contain('AllowOverride All').from("<Directory #{vhost['docroot']}>").to('</Directory>') }
	     it { should contain("ServerName #{vhost['main_domain']}").before("DocumentRoot #{vhost['docroot']}") }
	     it { should contain("ServerAlias #{vhost['aliases']}").after("ServerName #{vhost['main_domain']}") }
	     it { should contain('DirectoryIndex index.html index.htm index.php') }
	   end

	   describe file("/etc/apache2/sites-enabled/#{vhost['main_domain']}.conf") do
	     it { should be_linked_to "../sites-available/#{vhost['main_domain']}.conf" }
	   end
	 end
end
