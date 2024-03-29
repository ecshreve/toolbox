# toolbox

## Todo

- [ ] Add `docker` role
- [ ] Add `aliases` to .zshrc
- [ ] Configure `charm` server to run via docker, back it up to NAS
- [ ] Use `skate` to handle secrets
- [ ] Bake all of this into a docker image

## Usage

### Install script

- Installs python3 and pip via `apt`
- Installs ansible via `pip`
- Clones this repository to `$HOME/.toolbox`
- Runs the ansible playbook

### Ansible Roles

#### `shell`

Handles initial basic setup of shell environment. The tasks in this role
prepare to use ansible to install and configure the rest of the environment.

- zsh and oh-my-zsh
- zsh plugins
    - zsh-syntax-highlighting
    - zsh-autosuggestions
    - zsh-completions
    - git
    - forgit
    - fzf
- install Powerlevel10k theme
- copy powerlevel10k configuration and .zshrc to `$HOME`

#### `golang`

Installs Golang and sets up the environment. Configurable via the `golang`
section of `config-vars.yml` file.

- Installs Golang to `$HOME/.local/go`
- Installs executables to `$HOME/.local/bin`
