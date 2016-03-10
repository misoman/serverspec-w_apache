require 'spec_helper'

RSpec.shared_examples 'w_apache::varnish_integration' do

	describe file('/var/www/html/ping.php') do
	  it { should be_file }
	  it { should contain '<html><body>website is healthy</body></html>' }
	end

  # commented as it is not tested in different IP range
	#describe host('0varnish.examplewebsite.com') do
  #  it { should be_resolvable.by('hosts') }
  #  its(:ipaddress) { should eq '172.31.2.12' }
  #end

end