require 'spec_helper'

describe 'augeas_base::settings_to_file' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do

      let :facts do
        facts
      end

      relevant_file = '/etc/ssh/sshd_config'
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
        it { is_expected.to contain_file(relevant_file) }
        it { is_expected.to contain_augeas(relevant_file_augeas_path) }
        it { is_expected.to contain_augeas(relevant_file_augeas_path).with_changes(['set "HostKey" "/etc/ssh/ssh_host_key"',
                                                                                    'set "Port" "23"'])}
        # it { pp catalogue.resources }
      end

      context 'global lens definition' do

        specific_lens = 'Sshd.lns'
        let(:pre_condition) {
          <<-EOS
          class { 'augeas_base':
            default_lens => '#{specific_lens}'
          }
          EOS
        }

        it { is_expected.to compile }
        it { is_expected.to contain_augeas_base__settings_to_file(relevant_file) }
        it { is_expected.to contain_file(relevant_file) }
        it { is_expected.to contain_augeas(relevant_file_augeas_path) }
        it { is_expected.to contain_augeas(relevant_file_augeas_path).with_changes(['set "HostKey" "/etc/ssh/ssh_host_key"',
                                                                                    'set "Port" "23"'])
                                                                  .with_lens(specific_lens)}
      end
    end
  end
end
