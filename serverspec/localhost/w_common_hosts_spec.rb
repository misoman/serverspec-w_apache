require 'spec_helper'

describe 'w_common::hosts' do

  describe host('0db.example.com') do
    it { should be_resolvable.by('hosts') }
    its(:ipaddress) { should eq '172.31.6.12' }
  end

  describe host('0webapp.example.com') do
    it { should be_resolvable.by('hosts') }
    its(:ipaddress) { should eq '172.31.3.12' }
  end
end
