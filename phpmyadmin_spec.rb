require 'spec_helper'

RSpec.shared_examples 'w_apache::phpmyadmin' do

  describe file('/websites/phpmyadmin/config.inc.php') do
    it { should be_file }
  end
end
