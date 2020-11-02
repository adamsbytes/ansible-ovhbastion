ovhbastion
=========

This role installs and configures the [OVH Bastion](https://github.com/ovh/the-bastion) software package. The ovhbastion role is based on the [official OVH Bastion installation instructions](https://ovh.github.io/the-bastion/installation/basic.html). Please visit [the official OVH Bastion documentation](https://ovh.github.io/the-bastion/index.html) for more information.

Once you run this role, [click here](https://ovh.github.io/the-bastion/using/basics.html) to view the next steps in configuring OVH Bastion.

Tested On
------------

- Debian 8+
- Ubuntu 18+

Role Variables
--------------

#### Required
`ssh_key`: string with public ssh key for access to initial admin account
#### Recommended
`bastion_name`: string with name of bastion host. the system's actual hostname is _not_ recommended.

See `defaults/main.yml` for optional variables that can be set.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: all
    become: yes
    gather_facts: yes
    roles:
      - role: ovhbastion

License
-------

GPLv3

Author Information
------------------

https://github.com/adamsbytes
