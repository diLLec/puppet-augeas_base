require 'spec_helper_acceptance'

describe 'augeas_base::dirsettings_to_file' do
  context 'augeas_base::dirsettings_to_file - oversight test' do
    config_file = '/etc/ssh/sshd_config_test'
    specific_user = 'asterisk'

    manifest =
    <<-EOS
    class { '::augeas_base':
      default_lens => 'Sshd.lns',
      default_owner => '#{specific_user}'
    }->
    augeas_base::dirsettings_to_file { '#{config_file}':
      dirsettings => {
        'ChrootDirectory' => '/tmp/myssh'
      },
      filesettings => {
        'HostKey' => '/etc/ssh/ssh_host_key',
        'HostCertificate' => '/etc/pki/tls/cert.pem',
        'PidFile' => '/var/run/mysshd.pid'
      },
    }
    EOS

    run_manifest manifest

    describe file(config_file) do
      it { should exist }
      its(:content) { should match /ChrootDirectory \/tmp\/myssh/ }
      its(:content) { should match /HostKey \/etc\/ssh\/ssh_host_key/ }
    end

    describe file('/tmp/myssh') do
      it { should exist }
      it { should be_owned_by specific_user}
    end

    %w(/etc/ssh/ssh_host_key /etc/pki/tls/cert.pem /var/run/mysshd.pid).each do |filename|
      describe file(filename) do
        it { should exist }
        it { should be_owned_by specific_user}
      end
    end

  end
end

