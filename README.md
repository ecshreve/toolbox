# toolbox

## Todo

- [ ] Add `aliases` to .zshrc
- [/] Configure `charm` server to run via docker, back it up to NAS
- [/] Use `skate` to handle secrets
- [ ] Bake all of this into a docker image
- [ ] Take a few cycles to clean up the `golang` role.
- [ ] Audit .yml vs .yaml file extensions
- [?] Add `tmux` configuration
- [?] Add `docker` role

## Usage

### Install script

- Installs `python3` and `pip` via `apt`
- Installs ansible via `pip`
- Clones this repository to `$HOME/.toolbox`
- Runs the `ansible` playbook

### Ansible Roles

I use `ansible` to manage most of the dotfiles and configurations on my system. 
The roles are defined in the `ansible/roles` directory, and the playbook 
`dev_setup.yml` is responsible for running them.

**`shell`**

- Handles the installation and configuration of `zsh` and `oh-my-zsh`, as well 
  as a few plugins and utilities.

- Configuration for `zsh` is defined in `roles/shell/files/zshrc`, which is 
  copied to `$HOME/.zshrc` after installation. 
  
    > [!IMPORTANT]
    > The `.zshrc` configuration defines a keybinding override to use `^ff` 
    instead of `^t` to trigger `fzf` from the command line.

- Uses `powerlevel10k` for prompt styling.
- Installs `fzf` and `forgit` for fuzzy searching and git integration.
- Installs `zsh-autosuggestions`, `zsh-completions`, `zsh-syntax-highlighting` 
  for enhanced shell functionality.

**`golang`**:

- Handles downloading and installing Golang 1.21.8, along with additional tools 
  and executables.
- Installs go under `$HOME/go/`
- Installs executables under `$HOME/.local/bin`
- Version to install and packages to install are defined in `roles/config-vars.yml`

    > [!NOTE]
    > This task is buggy right now and doesn't handle updating existing installations.

### General CLI Tools

- `exa` - A modern replacement for `ls`
- `bat` - A modern replacement for `cat`
- `fd` - A modern replacement for `find`
- `fzf` - A fuzzy finder for the command line
- `forgit` - A `fzf` wrapper for `git` commands
- `tldr` - A streamlined `man` page replacement

### Go CLI Tools
- `run` - A utility to run commands in a new shell
- `skate` - A utility to manage secrets
- `charm` - A utility to manage `charm` apps
- `mods` - An application to interact with the OpenAI API
- `gum` - A tool for glamorous shell scripts
