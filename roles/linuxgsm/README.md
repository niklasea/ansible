# LinuxGSM

Requires Ansible version 2.5

It is also possible to use this role with a non-sudo account simply by manually installing any dependencies beforehand. Game server dependencies can be found on the LGSM website: https://linuxgsm.com/servers/

### Example play for non-root LGSM user:

```yaml
- name: Example LGSM server
  hosts: example
  pre_tasks:
    - name: Add LGSM user
      become: true
          user:
        name: exampleuser
        shell: /bin/bash

    - name: Set SSH key taken from file
      become: true
          authorized_key:
        user: exampleuser
        state: present
        key: "{{ lookup('file', 'exampleuserssh.pub') }}"

    - block:
        - block:
            - name: Check if i386 is enabled
              command: dpkg --print-foreign-architectures
              register: result_i386_check
              changed_when: false
              failed_when: false

            - name: Enable i386 architecture if necessary
              become: true
              command: dpkg --add-architecture i386
              when: "'i386' not in result_i386_check.stdout"

            - name: Update apt cache after adding i386 architecture (required for libstdc++6:i386)
              apt:
                update_cache: true
              when: "'i386' not in result_i386_check.stdout"
          when: ansible_architecture != 'i386'

        - name: Install role dependencies (Debian)
          become: true
                  package:
            name:
              - python*-apt
              - cron
              - curl
              - tar
              - wget
              - util-linux
              - file
              - gzip
              - bzip2
              - unzip
              - binutils
              - bc
              - jq
              - tmux
              - lib32gcc1
              - libstdc++6
              - libstdc++6:i386
      when: ansible_os_family == 'Debian'

    - name: Install role dependencies (CentOS)
      become: true
          package:
        name:
          - epel-release
      when: ansible_distribution == 'CentOS'

    - name: Install role dependencies (RedHat)
      become: true
          package:
        name:
          - cronie
          - curl
          - tar
          - wget
          - util-linux
          - file
          - gzip
          - bzip2
          - unzip
          - binutils
          - bc
          - jq
          - tmux
          - glibc.i686
          - libstdc++
          - libstdc++.i686
      when: ansible_os_family == 'RedHat'

  tasks:
    - import_role:
        name: linuxgsm
      remote_user: "{{ linuxgsm_user }}"
      vars:
        linuxgsm_game: csgoserver
        linuxgsm_user: exampleuser
        linuxgsm_auto_install_deps: false
```

# Troubleshooting

### 1. Package openjdk-8-jre-headless is not available...

The LGSM installer currently does not install the correct Java package on Debian 8 and Debian 10. The simplest solution is to manually run `apt install default-jre` to get a supported JRE.
