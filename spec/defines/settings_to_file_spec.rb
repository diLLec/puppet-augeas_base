require 'spec_helper'

describe 'augeas_base::settings_to_file' do
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
            settings: {
                'HostKey' => '/etc/ssh/ssh_host_key',
                'Port' => '23',
            }
        }
      end
      context 'simple inifile' do
        it { is_expected.to compile }
        it { is_expected.to contain_augeas_base__settings_to_file(relevant_file) }
        it { is_expected.to contain_file(relevant_file).without_owner().without_group() }
        it { is_expected.to contain_augeas(relevant_file_augeas_path).with_changes(['set "HostKey" "/etc/ssh/ssh_host_key"',
                                                                                    'set "Port" "23"'])}
      end

      context 'global lens and owner definition' do
        specific_lens = 'Sshd.lns'
        specific_owner = 'asterisk'
        let(:pre_condition) {
          <<-EOS
          class { 'augeas_base':
            default_lens => '#{specific_lens}',
            default_owner => '#{specific_owner}',
          }
          EOS
        }

        it { is_expected.to compile }
        it { is_expected.to contain_class('augeas_base') }
        it { is_expected.to contain_user('asterisk') }
        it { is_expected.to contain_group('asterisk') }
        it { is_expected.to contain_augeas_base__settings_to_file(relevant_file) }
        it { is_expected.to contain_file(relevant_file).with_owner(specific_owner).with_group(specific_owner) }
        it { is_expected.to contain_augeas(relevant_file_augeas_path).with_changes(['set "HostKey" "/etc/ssh/ssh_host_key"',
                                                                                    'set "Port" "23"'])
                                                                     .with_lens(specific_lens) }
      end
    end
  end
end
