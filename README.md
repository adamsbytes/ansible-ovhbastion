ansible-ovhbastion
=========
[![Build Status](https://travis-ci.com/adamsbytes/ansible-ovhbastion.svg?branch=main)](https://travis-ci.com/adamsbytes/ansible-ovhbastion)

This role installs and configures [OVH Cloud](https://www.ovh.com/world/)'s [the Bastion](https://github.com/ovh/the-bastion) secured jump host server. The ovhbastion role is based on the [official  Bastion installation instructions](https://ovh.github.io/the-bastion/installation/basic.html). Please visit [the official Bastion documentation](https://ovh.github.io/the-bastion/index.html) for more information.

Once you run this role, [click here](https://ovh.github.io/the-bastion/using/basics.html) to view the next steps in configuring the Bastion.

Tested On
------------

- Debian 8+
- Ubuntu 18+

Role Variables
--------------

#### Required
`ssh_key`: string with public ssh key for access to initial admin account

#### Recommended
`bastion_name`: string with name of bastion host. the system's actual hostname is _not_ recommended\
`bastion_create_admin`: toggle creation of the superadmin account\
`bastion_superadmin_uname`: string with username for the bastion superadmin (if enabled)

See `defaults/main.yml` for optional variables that can be set.

Role Installation
------------

```bash
$ ansible-galaxy install adamsbytes.ovhbastion
```

Example Playbook
----------------

```yaml
- hosts: all
  become: yes
  gather_facts: yes
  roles:
    - role: adamsbytes.ovhbastion
  vars:
    ssh_key: "YOUR_PUBLIC_SSH_KEY_HERE"
```

License
-------

GPLv3

Author Information
------------------

https://github.com/adamsbytes
