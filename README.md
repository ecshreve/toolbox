#  toolbox 

A collection of tools, configuration files, notes, and scripts.

Used to manage development environment(s) and tools across machines, operating systems, containers, and virtual machines.

## Usage

During active development I run the `ansible` playbook either locally or in a container to configure my development environment.

> [!NOTE]
> Probably don't run the install script, it does things.

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


## Ansible

### Playbook

The `playbook.yml` file is the main entry point for the `ansible` configuration.

### Roles

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
  

## Links

- [ansible](https://docs.ansible.com/ansible/latest/index.html)
- [fzf](https://github.com/junegunn/fzf)
- [zsh](https://www.zsh.org/)
- [oh-my-zsh](https://ohmyz.sh/)
