require 'spec_helper'

RSpec.shared_examples 'w_apache::php' do

  unless `hostname`.include?('-source-') then
    ['php5-fpm', 'php-pear', 'php5-dev', 'php5-mysql', 'php5-memcached', 'php5-gd', 'php5-pspell', 'php5-curl'].each do |package|
      describe package("#{package}") do
        it { should be_installed }
      end
    end
  end

  describe file('/etc/php5/fpm/pool.d/www.conf') do
    it { should_not exist }
  end

  %w(maxlifetime php5-fpm-checkconf php5-fpm-reopenlogs sessionclean).each do |script|
    describe file("/usr/lib/php5/#{script}") do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 755 }
      its(:content) { should match /\/etc\/php5\/fpm\/php-fpm.conf/ } if script.include?('php5-fpm')
    end
  end

  describe file('/etc/init.d/php5-fpm') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe file('/etc/init/php5-fpm.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
  end

  describe file('/etc/php5/mods-available') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe file('/etc/php5/fpm/php-fpm.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /pid(\s)+=(\s)+\/var\/run\/php5-fpm.pid/ }
    its(:content) { should match /error_log(\s)+=(\s)+\/var\/log\/php5-fpm\/fpm-master.log/ }
    its(:content) { should match /log_level(\s)+=(\s)+notice/ }
    its(:content) { should match /emergency_restart_threshold(\s)+=(\s)+16/ }
    its(:content) { should match /emergency_restart_interval(\s)+=(\s)+1h/ }
    its(:content) { should match /process_control_timeout(\s)+=(\s)+30s/ }
    its(:content) { should match /daemonize(\s)+=(\s)+yes/ }
    its(:content) { should match /events.mechanism(\s)+=(\s)+epoll/ }
  end

  describe file('/etc/php5/fpm/conf.d') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe file('/etc/php5/fpm/pool.d/php-fpm.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /user(\s)+=(\s)+www-data/ }
    its(:content) { should match /group(\s)+=(\s)+www-data/ }
    its(:content) { should match /catch_workers_output(\s)+=(\s)+no/ }
    its(:content) { should match /listen(\s)+=(\s)+/ }
    its(:content) { should match /listen.owner(\s)+=(\s)+root/ }
    its(:content) { should match /listen.group(\s)+=(\s)+root/ }
    its(:content) { should match /listen.mode(\s)+=(\s)+0666/ }
    its(:content) { should match /pm(\s)+=(\s)+dynamic/ }
    its(:content) { should match /pm.max_children(\s)+=(\s)+64/ }
    its(:content) { should match /pm.start_servers(\s)+=(\s)+4/ }
    its(:content) { should match /pm.min_spare_servers(\s)+=(\s)+4/ }
    its(:content) { should match /pm.max_spare_servers(\s)+=(\s)+32/ }
    its(:content) { should match /pm.max_requests(\s)+=(\s)+10000/ }
    its(:content) { should match /pm.status_path(\s)+=(\s)+\/fpm-status/ }
    its(:content) { should match /ping.path(\s)+=(\s)+\/fpm-ping/ }
    its(:content) { should match /ping.response(\s)+=(\s)+pong/ }
    its(:content) { should match /request_terminate_timeout(\s)+=(\s)+320/ }
    its(:content) { should match /chdir(\s)+=(\s)+\// }
    its(:content) { should match /security.limit_extensions(\s)+=(\s)+.php .htm .php3 .html .inc .tpl .cfg/ }
    its(:content) { should match /php_value\[error_log\](\s)+=(\s)+\/var\/log\/php5-fpm\/php-fpm.log/ }
  end

  describe file('/var/run/php5-fpm.sock') do
    it { should be_socket }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 666 }
  end

  describe file('/etc/php5/fpm/php.ini') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
  end

  describe file('/var/log/php5-fpm') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe file('/etc/logrotate.d/php5-fpm') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /rotate(\s)+4/ }
    its(:content) { should match /weekly/ }
    its(:content) { should match /copytruncate/ }
    its(:content) { should match /missingok/ }
    its(:content) { should match /notifempty/ }
    its(:content) { should match /sharedscripts/ }
    its(:content) { should match /delaycompress/ }
    its(:content) { should match /postrotate/ }
    its(:content) { should match /\/bin\/kill -SIGUSR1 `cat \/var\/run\/php5-fpm.pid 2>\/dev\/null` 2>\/dev\/null \|\| true/ }
    its(:content) { should match /endscript/ }
  end

  describe service('php5-fpm') do
    it { should be_enabled }
    it { should be_running }
  end
end
