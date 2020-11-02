ovhbastion
=========

This role installs and configures the OVH Bastion software package.

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

See `vars/main.yml` for optional variables that can be set.

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
