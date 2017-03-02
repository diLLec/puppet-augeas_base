require 'spec_helper'

describe 'augeas_base::dirsettings_to_file' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do

      let :facts do
        facts
      end

      relevant_file = '/etc/ssh/sshd_config_test'
      relevant_file_augeas_path = "/files#{relevant_file}"
      let(:title) { relevant_file }
      let(:params) do
        {
            dirsettings: {
                'ChrootDirectory' => '/tmp/myssh'
            },
            filesettings: {
                'HostKey' => '/etc/ssh/ssh_host_key',
                'HostCertificate' => '/etc/pki/tls/cert.pem',
                'PidFile' => '/var/run/mysshd.pid'
            }
        }
      end
      context 'augeas_base::dirsettings_to_file - simple' do
        it { is_expected.to compile }
        it { is_expected.to contain_augeas_base__dirsettings_to_file(relevant_file) }
        it { is_expected.to contain_augeas_base__settings_to_file(relevant_file) }
        it { is_expected.to contain_file('/etc/ssh/ssh_host_key').with_ensure('file') }
        it { is_expected.to contain_file('/etc/pki/tls/cert.pem').with_ensure('file') }
        it { is_expected.to contain_file('/var/run/mysshd.pid').with_ensure('file') }
        it { is_expected.to contain_file('/tmp/myssh').with_ensure('directory') }
      end

      context 'augeas_base::dirsettings_to_file - with global default_owner' do
        specific_owner = 'asterisk'
        let(:pre_condition) {
          <<-EOS
          class { 'augeas_base':
            default_owner => '#{specific_owner}',
          }
          EOS
        }

        it { is_expected.to compile }
        it { is_expected.to contain_augeas_base__dirsettings_to_file(relevant_file) }
        it { is_expected.to contain_augeas_base__settings_to_file(relevant_file) }
        %w(/etc/ssh/ssh_host_key /etc/pki/tls/cert.pem /var/run/mysshd.pid).each do |filename|
          it { is_expected.to contain_file(filename).with_ensure('file').with_owner(specific_owner).with_group(specific_owner) }
        end
        it { is_expected.to contain_file('/tmp/myssh').with_ensure('directory').with_owner(specific_owner).with_group(specific_owner) }
      end
    end
  end
end
