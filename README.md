# ansible


## Requirements

- Ansible installed on your local computer
- Your SSH public key on each target machine

## Installation

Clone this repo. Add targets to your Ansible hosts file. Configure the network in /group_vars/all and run a playbook.

```
ansible_playbook initialise.yml --ask-become-pass
```
