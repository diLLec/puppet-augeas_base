# augeas_base module

![Travis Build State](https://travis-ci.org/diLLec/puppet-augeas_base.svg?branch=master)

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with augeas_base module](#setup)
    * [What augeas_base module affects](#what-augeas_base module-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with augeas_base module](#beginning-with-augeas_base module)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

The augeas_base module adds defines to your toolkit, which help to turn settings hashes into
configuration files. 

## Setup
### Setup Requirements

The module requires, that you have the following puppet environment
* puppet 3 or 4
* augeas feature enabled
* librarian or r10k to resolve dependencies
* to run tests
    * rspec-puppet
    * beaker/serverspec

### Beginning with augeas_base module
After adding augeas_base to your module dependencies, the module should be 
automatically loaded on each puppet run.

## Usage
### Use of augeas_base::settings_to_file 
The `settings_to_file` define, will resolve the specified 'settings' hash 
into the specified file.  

    augeas_base::settings_to_file { '<file>':
      settings => {
        '<setting>' => '<setting-value>',
        ['<setting>' => '<setting-value>',]
      },
    }

Please see the define documentation for more specifics.

### overwrite global defaults
If you want to override specific defaults of the defines, you can define the `augeas_base` 
class like the following:

    class { '::augeas_base':
      default_lens => 'Sshd.lns',
    }->
    augeas_base::settings_to_file {...}


## Reference
The following defines are added:
* `augeas_base::settings_to_file`

The following classes are added:
* `augeas_base`

## Limitations
None known.

## Development
If you like to contribute, feel free to fork and create pull requests.

### run spec/lint tests
To run spec/lint tests use the following command

* `vagrant provision --provision-with=spec`
* `vagrant provision --provision-with=lint`
* alternatively, ssh to the box and use the cmdline out of `Vagrantfile`

### run acceptance tests locally
To run acceptance tests locally, run this:

    LOCAL_TEST=true rake serverspec_local
    
common way to do that:
* change `puppet-augeas_base/contrib/manifests/site.pp` to the contents of let(:manifest)
* run `vagrant provision --provision-with=puppet` on your host
* exec serverspec_local by one of the following ways:
** `vagrant provision --provision-with=serverspec_local`
** ssh into vagrant box and exec the cmdline out of the `Vagrantfile`
    