#  toolbox 

A collection of tools, configuration files, notes, and scripts.

Used to manage development environment(s) and tools across hardware, operating systems, containers, and virtual machines.

## Usage

On a fresh machine, clone the repo and run the `install.sh` script to configure the local environment. The script is a thin wrapper around an ansible playbook that targets localhost.

> [!NOTE]
> Probably don't run the install script directly, it does a lot of things.

While this was all tested against a macos host, most often I run some set of the ansible roles against a virtual machine or docker container remotely via ssh.

## Devbox - multipass VM

The `devbox-playbook.yml` file creates or starts a multipass VM and runs the ansible playbook on it. This has only been tested on multipass running on a macos host.

## Configuration

<!-- TODO: source these from the vars file? -->
### Aliases and Commands to Remember

- `CTRL+ff` - fuzzy search for files
- `gaa` - add all files to git
- `ga`  - add files to git interactively with `fzf`
- `gbb` - interactive branch selection with `fzf`
- `gcmsg <message>` - commit with a message
- `gcm` - checkout main branch
- `gcp` - interactive cherry-pick with `fzf`
- `gd`  - interactive git diff with `fzf`
- `gdoof` - add all and amend with no message
- `gll` - count lines in staged git diff
- `glo` - interactive git log with `fzf`
- `goops` - reset last commit soft
- `gss` - interactive stash selection with `fzf`
- `gup` - pull with rebase
- `nett` - show open ports

### General CLI Tools
- `bat` - A modern replacement for `cat`
- `eza` - A modern replacement for `ls`
- `fzf` - A fuzzy finder for the command line

## Ansible Roles

**`base`**
- Determines the operating system and package manager.
- Install packages (apt-get on debian/ubuntu) (brew on darwin/macos).

**`zsh`**:
- Install and configure of `zsh` and `oh-my-zsh`, plugins, and utilities.
- Install and configure `powerlevel10k` for prompt styling.

**`fzf`**:
- Install `fzf` from git repository.

**`dotfiles`**:
- Symlink shell configuration files in `config_files/` to `$HOME`.

> [!IMPORTANT]
> The `.zshrc` configuration defines a keybinding override to use `^ff` instead of `^t` to trigger `fzf` from the command line.

**`multipass`**:
- Create or start a multipass VM and add it to the inventory.

**`docker`**:
- Install docker and add the current user to the docker group.

**`asdf`**:
- Install and configure `asdf` and plugins.

> [!IMPORTANT]
> This is where installing different versions of languages and tools is managed.
> For example, `golang`, `python`, `terraform`, etc...

## Links

- [ansible](https://docs.ansible.com/ansible/latest/index.html)
- [fzf](https://github.com/junegunn/fzf)
- [zsh](https://www.zsh.org/)
- [oh-my-zsh](https://ohmyz.sh/)
- [multipass](https://multipass.run/)
- [docker](https://docs.docker.com/)
- [asdf](https://asdf-vm.com/)

