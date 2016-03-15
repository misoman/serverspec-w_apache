require 'spec_helper'

RSpec.shared_examples 'w_apache::php' do

  describe command('php -v') do
    its(:stdout) { should match /#{Regexp.quote(php_minor_version)}/ }
    its(:stdout) { should match /with blackfire/}
  end

  standard_packages = %w(bcmath bz2 cli common curl dev enchant fpm gd gmp imap interbase intl ldap mbstring mcrypt mysql odbc opcache pgsql phpdbg pspell readline recode soap sqlite3 sybase tidy xmlrpc xml zip).map {|package| "php#{php_minor_version}-#{package}"}
  additional_packages = %w(amqp geoip gettext gmagick igbinary imagick mailparse memcached mongodb msgpack pear radius redis rrd smbclient ssh2 uuid yac zmq).map {|package| "php-#{package}"}

  ( standard_packages + additional_packages ).each do |package|
    describe package("#{package}") do
      it { should be_installed }
    end
  end

  %W( php#{php_minor_version}-cgi php#{php_minor_version}-snmp php-apcu php-ast php-uploadprogress libapache2-mod-php ).each do |package|
    describe package("#{package}") do
      it { should_not be_installed }
    end
  end

  %W(php#{php_minor_version}-fpm-checkconf php#{php_minor_version}-fpm-reopenlogs php-helper php-maintscript-helper sessionclean).each do |script|
    describe file("/usr/lib/php/#{script}") do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }

      if script.include?('php-') then
        it { should be_mode 644 }
      else
        it { should be_mode 755 }
      end
    end
  end

  describe file("/etc/init.d/php#{php_minor_version}-fpm") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe file("/etc/php/#{php_minor_version}/mods-available") do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe file("/etc/php/#{php_minor_version}/fpm/php-fpm.conf") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /pid(\s)+=(\s)+\/run\/php\/php#{Regexp.quote(php_minor_version)}-fpm.pid/ }
    its(:content) { should match /error_log(\s)+=(\s)+\/var\/log\/php#{Regexp.quote(php_minor_version)}-fpm.log/ }
    its(:content) { should match /log_level(\s)+=(\s)+notice/ }
    its(:content) { should match /emergency_restart_threshold(\s)+=(\s)0/ }
    its(:content) { should match /emergency_restart_interval(\s)+=(\s)0/ }
    its(:content) { should match /process_control_timeout(\s)+=(\s)0/ }
    its(:content) { should match /daemonize(\s)+=(\s)+yes/ }
    its(:content) { should match /events.mechanism(\s)+=(\s)+epoll/ }
  end

  describe file("/etc/php/#{php_minor_version}/fpm/conf.d") do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe file("/etc/php/#{php_minor_version}/fpm/pool.d/www.conf") do
    it { should_not exist }
  end

  describe file("/etc/php/#{php_minor_version}/fpm/pool.d/php-fpm.conf") do
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
    its(:content) { should match /php_value\[error_log\](\s)+=(\s)+\/var\/log\/php#{Regexp.quote(php_minor_version)}-fpm.log/ }
  end

  describe file("/var/run/php/php#{php_minor_version}-fpm.sock") do
    it { should be_socket }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 666 }
  end

  describe file("/etc/php/#{php_minor_version}/fpm/php.ini") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
  end

  describe file("/var/log/php#{php_minor_version}-fpm.log") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 600 }
  end

  describe file("/etc/logrotate.d/php#{php_minor_version}-fpm") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /rotate(\s)12/ }
    its(:content) { should match /weekly/ }
    its(:content) { should match /missingok/ }
    its(:content) { should match /notifempty/ }
    its(:content) { should match /compress/ }
    its(:content) { should match /delaycompress/ }
    its(:content) { should match /postrotate/ }
    its(:content) { should match /\/usr\/lib\/php\/php#{Regexp.quote(php_minor_version)}-fpm-reopenlogs/}
    its(:content) { should match /endscript/ }
  end

  describe file("/etc/init.d/php#{php_minor_version}-fpm") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe file("/usr/sbin/php-fpm#{php_minor_version}") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe service("php#{php_minor_version}-fpm") do
    it { should be_enabled }
    it { should be_running }
  end
end
