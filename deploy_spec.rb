require 'spec_helper'

RSpec.shared_examples 'w_apache::deploy' do

  describe host('git.examplewebsite.com') do
    it { should be_resolvable.by('hosts') }
    its(:ipaddress) { should eq '9.9.9.9' }
  end

  describe file('/var/www/.ssh') do
    it { should be_directory }
    it { should be_mode 700 }
    it { should be_owned_by 'www-data' }
    it { should be_grouped_into 'www-data' }
  end

  describe file('/var/www/.ssh/id_rsa') do
    it { should be_file }
    it { should be_mode 600 }
    it { should be_owned_by 'www-data' }
    it { should be_grouped_into 'www-data' }
    it { should contain '-----BEGIN RSA PRIVATE KEY-----CHIOpAIBAAKCAQEA4tcgfvo5E7HG3u+Bl1zDHmW+L4vbCE31PlCzPnUA+1iLfb6Sv1x/ibzhVsFXALP0LON5lL2/3wf6B+qH7t6JpsmYo8qsWpmKy2J7pygQYrmHsxhxxaVU2NEhZT/uhWLKzF40yJ74/of5yBxwutoESYEl1YIilPiGJaWMmQtFUlCiHa7iZQ0Rx7w+A/waxnslA1cajwb3T4PdmLK5zPd8c+089BiCXzJgrKsGSJQ0Ea/EemoU2LIwvs75P3e6necmMSpjqaZGr9s87orbKq1pNyh3/QWzn4C3OKj8QX1m/g51YkUvzTSJzLeJMZygrhSCEU4KoqmwMWW8yUmLMs2xLQIBIwKCAQEAlREGudeh2b33txJrGlLmnvJnCU1GyvFmpUr5ci+hjzovx6kemwJFLqCxVkSJoWBQAD22S80mULwZVai/ujp3tr795/o2vzGy+q5ug8ne4cpgfQFvVf7unRu23CKyr2zOaQq0+N1/DanQByih2d+5rKVTYGt1z5wAYeHRa+LVyF+ixRjZh8kl0y74V32MpWoLddDjK4t5Kcqp/YRJ+cZrj0sqZhIKotbowhbzPZm4a9s7tqbsgLzTbKZPDLqibA1sxtC0DjfavaVEG79QWw+ReNJpxXLCK6LuoiOlJTheOkkX9OT0Hmt4UKILtQsNxASzwD6omQT1L1zqj/d1G/dutwKBgQD2UbMPrhxyjQktLCM7EUCcQvs7siyPGzdCxCsYy8fLEYnHD+8BIaqbfdmzpcca5US0UluTUHBG89qshKN8GlhGqGoghxrvT9QOMvL4vz/bx5Bc3CWyAaqR0rLoPMIRyJdhxMP2oDNKw6j3dF1s6KyBlH16zGoVyhse8AJTjXhGYwKBgQDrwXHVmmV77jPv+aqEHa9sLncKu/sI3nE/Gxdc9GXsUK5LoeGHUNyPgeYNAkdZk2tcPqEv5b5lRwJwAICVQ03sF2xoyiAVo5xi6mmfypik72MK3iY+UE2Cm7/V7XvQ8wfY5g6OCdgjxgG3k3xLWFW3TSNMfhaq3G9PKrhkC3i3LwKBgQDvSA0H6vcQMTwdQNHEWeb+MnBl4EiLBH7TJPaqX47ihhDQANmMEhNyekEyLAM+stUG8Os+pelpfywyj3o+CvarCgCx4lSt9cautSaLPXE75m77HwAMAZ5hxV1WoWwRRoRtmpJ6jP6gZkxeGUTQMnuxE+eb3IRPrmN9I6p9DRXAtwKBgQCa7NXG4c2pNiIhWuxlcpfZYFzbKxKuDoTu9IuyHPKFWZcbwiZ9fkfMBOeiJhGhQ55Sj45+j6kAuaJ1qI8DAFfHCBQKWPCDP6FIUOZTEBsqjq7MoJzJ3P+8Ona/x/JHeyJp9kQUMlrVrgEg3UMM8Ofe2utPhg7lTwdRR/WDkoKHAQKBgQDeqRjEqLVs8sHu49PeVY2v/JbDhWHLmyCTP7v8tn9UA/E0JATz8/7lEr5nqGoWx7MK4AYv4QUIRH9eamkMA8TZy7gAPCCb13wllU0ntbD7Dtm0RioxGwnD4GeQEBwIQ4BdMl4wbDmPt9rhBEGkD0vGDkmbU4iHoWK8rC0EHrgCsQ+=-----END RSA PRIVATE KEY-----' }
  end

  describe file('/var/www/.ssh/authorized_keys') do
    it { should be_file }
    it { should be_owned_by 'www-data' }
    it { should be_grouped_into 'www-data' }
    it { should contain 'ssh-rsa RAAAB3NzaC1yc2EAAAADAQABAAABAQDFrcjKWXebaCrE49CikRd1ScSuRdbMuJ6aMxBtg9RuA9c2Lzn70YF8uoSXl0xwdhxIG4O+ft6lL4TwJy80J+Hs1cUE/GxemLDYSVwfG61+AqDonYnMRvdeYsWxfTi5lINA60IIUkvv5fNS69FLRoJT8sZdUDX9rF/swuEohcVT3GVUyKfGZtEJcASYwSiHXiyJ3tgfFNTeRZKw/qMWX+bSCUbFAJrQyHzg0FobEVWyUdlUvNXnNI8vlhh6qbnq4cPmRWqsosEPWe3CjDArzgMs3mwez0+7S3SrBf3mNqbzH0E/RhsrQqOuHHPVOz/aVlcKEhaSqiBTXwPn9xZjS4lL jenkins@jenkins.examplewebsite.com' }
  end

  describe file('/var/www/.ssh/known_hosts') do
    it { should be_file }
    it { should be_owned_by 'www-data' }
    it { should be_grouped_into 'www-data' }
    it { should contain ' git.examplewebsite.com ssh-rsa QAAAB3NzaC1yc2EAAAADAQABAAABAQDN5u2/w1xQdJQWD+/omBz4iR8ZUvPiRRgk6O6MYy+vmrPr4w+GyMYfhvDylhW+BIil2mHDaY7XdMrJb1FlUoS4a0WxMbpvqffMlVQoYphtHbtqALCfD6s+KKIcE0nuwYU7gaMRHU9LFxdsjVv2wRGrW79b8u22ySLRdkKu9tSSfketWUP7CMiMELVEr1su5mTeR7j1oQUnoeA6w5fsFRtu5PHMS8i/-jdTwoG4qYWKbmVxqhzso+qG2rix4duJJ8LEN35wCkCO/nbTlXExEZevvjE7hNPmQ5EULLN/jWy2Vuq0blqDKs6eN6+lzMME2iplNIKZdfvXO+e90zdHnJOL ' }
  end

  describe command('cd /websites/examplewebsite.com && git remote -v') do
    its(:stdout) { should contain('git.examplewebsite.com/www.git') }
  end

  describe command('cd /websites/examplewebsite.com/admin && git remote -v') do
    its(:stdout) { should contain('git.examplewebsite.com/admin.git') }
  end
end
